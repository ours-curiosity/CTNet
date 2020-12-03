//
//  CTNetTask.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
import Alamofire

public enum CTNetRequestMethod{
    case get
    case post

    func map()->HTTPMethod{
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        }
    }
}
class CTNetTask:Operation{
    var id:String
    var url:String
    var netCallBack:((_ data:[String: Any],_ taskID:String)->())
    var cacheID:String?
    var level:Operation.QueuePriority = .normal
    
    private var request:DataRequest?
    private var myMethod:HTTPMethod
    private var method: CTNetRequestMethod
    private var parameters:[String: Any]
    lazy private var session:Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = httpHeaders
        configuration.timeoutIntervalForRequest = CTNetConfigure.shared.timeout
        
        var evaluators = [String:ServerTrustEvaluating]()
        for key in CTNetConfigure.shared.HTTPEvaluators{
            if key != ""{
                evaluators[key] = DisabledTrustEvaluator()
            }
        }
        
        if evaluators.isEmpty{
            let session = Alamofire.Session(configuration: configuration)
            return session
        }else{
            let serverTrustManager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: evaluators)
            let session = Alamofire.Session(configuration: configuration,serverTrustManager: serverTrustManager)
            return session
        }
    }()
    private var httpHeaders:HTTPHeaders = {
        var headers: [HTTPHeader] = []
        for item in CTNetConfigure.shared.headers{
            let header = HTTPHeader(name: item.key, value: item.value)
        }
        return HTTPHeaders(headers)
    }()

    init(url: String,
         method: CTNetRequestMethod,
         parameters: [String: Any],
         level:Operation.QueuePriority = .normal,
         cacheID:String?,
         cacheCallBack: ((_ data:[String: Any]?)->())?,
         netCallBack: @escaping ((_ data:[String: Any],_ taskID:String)->())) {
        
        self.url = url
        if let myCacheID = cacheID{
            cacheCallBack?(CTNetAPICache.shared.get(id: myCacheID))
        }
        self.netCallBack = netCallBack
        self.cacheID = cacheID
        self.method = method
        self.myMethod = method.map()
        self.parameters = parameters
        self.id = url.md5
        self.level = level
        super.init()
    }
    override func main() {
        if !isCancelled{
            CTNetTaskRetryManager.shared.add(taskID: self.id, times: CTNetConfigure.shared.retryTimes)
            autoRequest()
            CTNetLog.log("优先级",level.rawValue)
        }
    }
    /// 网络请求
    func autoRequest(){
        request = session.request(url, method: myMethod, parameters: parameters,headers: httpHeaders).responseJSON { [weak self](response) in
            guard let self = self else {return}
            switch response.result {
            case .success(let json):
                //打印JSON数据
                CTNetLog.log("\(json)")
                if let result = json as? [String: Any]{
                    self.netCallBack(result, self.id)
                    if let myCacheID = self.cacheID{
                        CTNetAPICache.shared.set(id: myCacheID, dict: result)
                    }
                }else{
                    self.netCallBack(["error":"格式非标准json","errorCode": -1234], self.id)
                }
                
            case .failure(let error):
                CTNetLog.log("\(error.localizedDescription)")
                /// 重试
                if CTNetTaskRetryManager.shared.retry(taskID: self.id){
                    self.autoRequest()
                }else{
                    self.netCallBack(["errorMsg":error.localizedDescription,"errorCode":error.responseCode ?? -1], self.id)
                }
            }
        }
        request?.resume()
    }
}

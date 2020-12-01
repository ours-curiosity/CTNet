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
    var callBack:((_ data:[String: Any],_ taskID:String)->())
    var level:Operation.QueuePriority = .normal
    
    private var request:DataRequest?
    private var myMethod:HTTPMethod
    private var method: CTNetRequestMethod
    private var parameters:[String: Any]
    lazy private var session:Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = httpHeaders
        configuration.timeoutIntervalForRequest = CTNetConfigure.shared.timeout
        let session = Alamofire.Session.init(configuration: configuration)

        if CTNetConfigure.shared.isHTTPMode {
            var evaluators = [String:ServerTrustEvaluating]()
            for key in CTNetConfigure.shared.HTTPEvaluators{
                evaluators[key] = DisabledEvaluator()
            }
            session.serverTrustManager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: evaluators)
        }
        return session
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
         callBack: @escaping ((_ data:[String: Any],_ taskID:String)->())) {
        self.url = url
        self.callBack = callBack
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
                    self.callBack(result, self.id)
                }else{
                    self.callBack(["error":"格式非标准json","errorCode": -1234], self.id)
                }
                
            case .failure(let error):
                CTNetLog.log("\(error.localizedDescription)")
                /// 重试
                if CTNetTaskRetryManager.shared.retry(taskID: self.id){
                    self.autoRequest()
                }else{
                    self.callBack(["errorMsg":error.localizedDescription,"errorCode":error.responseCode ?? -1], self.id)
                }
            }
        }
        request?.resume()
    }
}

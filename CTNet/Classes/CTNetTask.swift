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
public class CTNetTask:Operation{
    var id:String
    var url:String
    var netCallBack:((_ data:[String: Any],_ taskID:String)->())
    var cacheID:String?
    var level:Operation.QueuePriority = .normal
    var autoCache = false
    private var header: [String:String] = CTNetConfigure.shared.headers
    private var request:DataRequest?
    private var myMethod:HTTPMethod
    private var method: CTNetRequestMethod
    private var parameters:[String: Any]
    private var timeout:Double = CTNetConfigure.shared.timeout
    
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
    lazy private var httpHeaders:HTTPHeaders = {
        var headers: [HTTPHeader] = []
        for item in self.header{
            let header = HTTPHeader(name: item.key, value: item.value)
            headers.append( header)
        }
        return HTTPHeaders(headers)
    }()

    init(url: String,
         method: CTNetRequestMethod,
         header: [String:String]?,
         parameters: [String: Any],
         level:Operation.QueuePriority = .normal,
         timeout:Double?,
         cacheID:String?,
         autoCache:Bool,
         cacheCallBack: ((_ data:[String: Any]?)->())?,
         netCallBack: @escaping ((_ data:[String: Any],_ taskID:String)->())) {
        
        self.url = url
        if let myCacheID = cacheID{
            cacheCallBack?(CTNetAPICache.shared.get(id: myCacheID))
        }else{
            if autoCache{
                cacheCallBack?(CTNetAPICache.shared.get(id: url))
            }
        }
        if let _header = header, _header.count != 0{
            self.header = header!
        }
        self.netCallBack = netCallBack
        self.autoCache = autoCache
        self.cacheID = cacheID
        self.method = method
        self.myMethod = method.map()
        self.parameters = parameters
        self.id = url.md5
        self.level = level
        if timeout != nil {
            self.timeout = timeout!
        }
        super.init()
    }
    public override func main() {
        if !isCancelled{
            autoRequest()
            CTNetLog.log("优先级",level.rawValue)
        }
    }
    /// 网络请求
    func autoRequest(){
        CTNetLog.log("\n【developer test】【CTNet】[\(url)][🚀]\n[params:\(parameters)]\n[header:\(httpHeaders)]\n")
        request = session.request(url, method: myMethod, parameters: parameters,encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { [weak self](response) in
            guard let self = self else {return}
            switch response.result {
            case .success(let json):
                //打印JSON数据
                CTNetLog.log("\n【CTNet】[\(response.request?.url?.absoluteString ?? "")][success✅]\n[response:\(json)]\n")
                if let result = json as? [String: Any]{
                    self.netCallBack(result, self.id)
                    if let myCacheID = self.cacheID{
                        CTNetAPICache.shared.set(id: myCacheID, dict: result)
                    }else{
                        if self.autoCache == true{
                            CTNetAPICache.shared.set(id: self.url, dict: result)
                        }
                    }
                }else{
                    self.netCallBack(["errMsg":"json is invalid","errCode": -13840], self.id)
                }
                
            case .failure(let error as NSError):
                /// 重试
                if CTNetTaskRetryManager.shared.retry(taskID: self.id){
                    /// 延迟重试，避免网络抖动
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.autoRequest()
                    }
                }else{
                    CTNetLog.log("\n【CTNet】[\(response.request?.url?.absoluteString ?? "")][fail❌]\n[error:\(error.localizedDescription)]\n")
                    self.netCallBack(["errMsg":"No connection","errCode":error.code], self.id)
                }
            }
        }
        request?.resume()
    }
}

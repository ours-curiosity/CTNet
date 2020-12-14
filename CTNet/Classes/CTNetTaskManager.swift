//
//  CTNetTaskManager.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
public struct CTNetError: Error {
    public var msg:String
    public var code:Int
    
    public init(msg: String, code: Int) {
        self.msg = msg
        self.code = code
    }
}
public class CTNetTaskManager{
    
    static let shared = CTNetTaskManager()
    private var myQueue : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = CTNetConfigure.shared.maxConcurrentOperationCount
        return queue
    }()
    private var tasks:[CTNetTask] = []
    /// 请求网络数据
    func request(url:String,
                 method: CTNetRequestMethod,
                 header: [String:String],
                 parameters: [String: Any],
                 level:Operation.QueuePriority,
                 timeout: Double?,
                 cacheID:String?,
                 autoCache:Bool,
                 cacheCallBack: ((_ data:[String: Any]?)->())?,
                 netCallBack: @escaping ((_ data:[String: Any]?,_ error:CTNetError?)->())) -> CTNetTask{
        
        let task = generateTask(url: url,
                                method: method,
                                header: header,
                                parameters: parameters,
                                level:level,
                                timeout: timeout,
                                cacheID:cacheID,
                                autoCache: autoCache,
                                cacheCallBack: cacheCallBack,
                                netCallBack: netCallBack)
        tasks.append(task)
        myQueue.addOperation(task)
        return task
    }
    
    
    /// 生成一个新的任务
    private func generateTask(url:String,
                              method: CTNetRequestMethod,
                              header: [String:String]?,
                              parameters: [String: Any],
                              level:Operation.QueuePriority,
                              timeout: Double?,
                              cacheID:String?,
                              autoCache:Bool,
                              cacheCallBack: ((_ data:[String: Any]?)->())?,
                              netCallBack: @escaping ((_ data:[String: Any]?,
                                                       _ error:CTNetError?)->()))
    -> CTNetTask{
        
        let totalURL = CTNetConfigure.shared.host + CTNetConfigure.shared.port + url
        let task = CTNetTask(url: totalURL,
                             method: method,
                             header: header,
                             parameters: parameters,
                             level: level,
                             timeout: timeout,
                             cacheID: cacheID,
                             autoCache: autoCache,
                             cacheCallBack: cacheCallBack,
                             netCallBack: { (jsonDict, taskID)in
                                self.removeTask(taskID: taskID)
                                var error : CTNetError?
                                if let code = jsonDict["errCode"] as? Int{
                                    let errorMsg = jsonDict["errMsg"] as? String ?? ""
                                    error = CTNetError(msg: errorMsg, code: code)
                                    netCallBack(jsonDict,error)
                                }
                                netCallBack(jsonDict,error)
                             })
        return task
    }
    /// 删除任务
    private func removeTask(taskID:String){
        tasks = tasks.filter { (task) -> Bool in
            if task.id == taskID{
                return false
            }else{
                return true
            }
        }
    }
    
}

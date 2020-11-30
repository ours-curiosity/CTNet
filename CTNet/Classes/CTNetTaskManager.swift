//
//  CTNetTaskManager.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
struct CTNetError
{
    var msg:String
    var code:Int
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
                 parameters: [String: Any],
                 level:Operation.QueuePriority,
                 callBack: @escaping ((_ data:[String: Any]?,_ error:CTNetError?)->())){
        
        let task = generateTask(url: url,
                                method: method,
                                parameters: parameters,
                                level:level,
                                callBack: callBack)
        tasks.append(task)
        myQueue.addOperation(task)
    }
    
    
    /// 生成一个新的任务
    private func generateTask(url:String,
                              method: CTNetRequestMethod,
                              parameters: [String: Any],
                              level:Operation.QueuePriority,
                              callBack: @escaping ((_ data:[String: Any]?,
                                                    _ error:CTNetError?)->()))
    -> CTNetTask{
        
        let totalURL = CTNetConfigure.shared.host + CTNetConfigure.shared.port + url
        let task = CTNetTask(url: totalURL, method: method, parameters: parameters,level: level, callBack: { (jsonDict, taskID)in
            self.removeTask(taskID: taskID)
            if let errorMsg = jsonDict["errorMsg"] as? String {
                if let code = jsonDict["errorCode"] as? Int{
                    let error = CTNetError(msg: errorMsg, code: code)
                    callBack(nil,error)
                }
            }else{
                callBack(jsonDict,nil)
            }
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

//
//  CTNetTaskRetryManager.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
class CTNetTaskRetryManager{
    
    static let shared = CTNetTaskRetryManager()
    
    var taskDictionary = [String:Int]()
    
    /// 添加重试任务 重试次数
    func add(taskID:String, times:Int){
        CTNetLog.log(taskID,"还剩\(times)重试机会")
        taskDictionary[taskID] = times
    }
    
    /// 移除重试任务
    func removeTask(task:CTNetTask){
        let id = task.id
        taskDictionary[id] = nil
    }
    
    /// 是否需要重试
    func retry(taskID:String)->Bool{
        
        if var times = taskDictionary[taskID]{
            times -= 1
            if times > 0{
                CTNetLog.log(taskID,"还剩\(times)重试机会")
                taskDictionary[taskID] = times
                return true
            }else{
                CTNetLog.log(taskID,"停止重试")
                taskDictionary[taskID] = nil
                return false
            }
        }
        return false
    }
}

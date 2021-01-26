//
//  CTNet.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

public extension Notification.Name {// 接到需要监听的错误码时的通知
    static let CTNetErrorCodeListener = Notification.Name.init("com.lfg.notification.CTNetErrorCodeListener")
}


public class CTNet{
    
    /// cacheID 缓存ID，如果有缓存，则根据缓存ID拿取，没有返回空，同时也是本次缓存的ID
    public static func request(url:String,
                        method: CTNetRequestMethod,
                        header: [String:String] = [:],
                        parameters: [String: Any],
                        level:Operation.QueuePriority = .normal,
                        timeout: Double?,
                        cacheID:String?,
                        autoCache:Bool,
                        cacheCallBack: ((_ data:[String: Any]?)->())?,
                        netCallBack: @escaping ((_ data:[String: Any]?,_ error:CTNetError?)->())) -> CTNetTask{
        
        return CTNetTaskManager.shared.request(url: url,
                                               method: method,
                                               header: header,
                                               parameters: parameters,
                                               level:level,
                                               timeout: timeout,
                                               cacheID:cacheID,
                                               autoCache: autoCache,
                                               cacheCallBack:cacheCallBack,
                                               netCallBack: netCallBack)
    }
    

    
}
 

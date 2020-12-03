//
//  CTNet.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

public class CTNet{
    
    /// cacheID 缓存ID，如果有缓存，则根据缓存ID拿取，没有返回空，同时也是本次缓存的ID
    public static func request(url:String,
                        method: CTNetRequestMethod,
                        parameters: [String: Any],
                        level:Operation.QueuePriority = .normal,
                        cacheID:String?,
                        cacheCallBack: ((_ data:[String: Any]?)->())?,
                        netCallBack: @escaping ((_ data:[String: Any]?,_ error:CTNetError?)->())){
        CTNetTaskManager.shared.request(url: url, method: method, parameters: parameters, level: level, cacheID:cacheID, cacheCallBack:cacheCallBack,netCallBack: netCallBack)
    }
    

    
}
 

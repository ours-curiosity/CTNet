//
//  CTNet.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

public class CTNet{
    
    static func request(url:String,
                        method: CTNetRequestMethod,
                        parameters: [String: Any],
                        level:Operation.QueuePriority = .normal,
                        callBack: @escaping ((_ data:[String: Any]?,_ error:CTNetError?)->())){
        CTNetTaskManager.shared.request(url: url, method: method, parameters: parameters, level: level, callBack: callBack)
    }
    

    
}
 

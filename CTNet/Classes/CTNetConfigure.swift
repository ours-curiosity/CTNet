//
//  CTNetConfigure.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

public class CTNetConfigure{
    var host:String = ""
    var port:String = ""
    var timeout:Double = 20
    var retryTimes:Int = 3
    var autoCache:Bool = true
    var maxConcurrentOperationCount:Int = 4

    var headers: [String:String] = [:]
    
    var debug = true
    
    static let shared:CTNetConfigure = {
        let configure = CTNetConfigure()
        return configure
    }()
    
    
}

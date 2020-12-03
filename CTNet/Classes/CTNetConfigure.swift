//
//  CTNetConfigure.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

public class CTNetConfigure{
    public var host:String = ""
    public var port:String = ""
    public var timeout:Double = 20
    public var retryTimes:Int = 3
    public var autoCache:Bool = true
    public var maxConcurrentOperationCount:Int = 4

    public var headers: [String:String] = [:]
    
    public var debug = true
    public var cachePath = NSHomeDirectory() + "/Documents/APIJsonCache/"
    /// http 验证赦免名单
    public var HTTPEvaluators = [""]
    
    public static let shared:CTNetConfigure = {
        let configure = CTNetConfigure()
        return configure
    }()
    
    
}

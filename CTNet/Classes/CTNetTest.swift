//
//  CTNetTest.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation

// MARK:优先级 测试 结果
/*
 *
 
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  0
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  4
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  4
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  0
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  0
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  0
 CTNetTask.swift[67], main(): CTNetLog  优先级 CTNetLog  0
 
 代码：
 CTNetConfigure.shared.host = "http://192.168.11.147"
 CTNetConfigure.shared.port = ":8080"

 CTNet.request(url: "/ping", method: .get, parameters: [:]) { (result,error) in

 }
 CTNet.request(url: "/ping1", method: .get, parameters: [:]) { (result,error) in

 }
 CTNet.request(url: "/ping2", method: .get, parameters: [:]) { (result,error) in

 }
 CTNet.request(url: "/ping3", method: .get, parameters: [:]) { (result,error) in

 }
 CTNet.request(url: "/ping4", method: .get, parameters: [:], level:.high) { (result,error) in

 }
 
 CTNet.request(url: "/ping5", method: .get, parameters: [:], level:.high) { (result,error) in

 }
 CTNet.request(url: "/ping6", method: .get, parameters: [:]) { (result,error) in

 }
 */
// MARK:重试 测试 结果

/*
 CTNetTaskRetryManager.swift[17], add(taskID:times:): CTNetLog  787bd5d01d1517dee0affa6e7d931c47 CTNetLog  还剩3重试机会
 CTNetTaskRetryManager.swift[33], retry(taskID:): CTNetLog  787bd5d01d1517dee0affa6e7d931c47 CTNetLog  还剩2重试机会
 CTNetTaskRetryManager.swift[33], retry(taskID:): CTNetLog  787bd5d01d1517dee0affa6e7d931c47 CTNetLog  还剩1重试机会
 CTNetTaskRetryManager.swift[37], retry(taskID:): CTNetLog  787bd5d01d1517dee0affa6e7d931c47 CTNetLog  停止重试
 
 代码：
 CTNetConfigure.shared.host = "http://192.168.11.147"
 CTNetConfigure.shared.port = ":8080"

 CTNet.request(url: "/ping", method: .get, parameters: [:]) { (result,error) in

 }
 
 */

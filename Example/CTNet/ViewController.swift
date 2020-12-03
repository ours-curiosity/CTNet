//
//  ViewController.swift
//  CTNet
//
//  Created by tliens on 11/30/2020.
//  Copyright (c) 2020 tliens. All rights reserved.
//

import UIKit
import CTNet
import RxSwift
import NSObject_Rx

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CTNetConfigure.shared.port = ":8080"
        CTNetConfigure.shared.host = "http://192.168.11.147"
        CTNetConfigure.shared.timeout = 20
        CTNetConfigure.shared.HTTPEvaluators = ["192.168.11.147"]
        
        /// codable
        UserNetManger.userInfo(usrid: "123").map { (json) -> UserInfo? in
            return (self.toModel(UserInfo.self, value: json))
        }.subscribe { (user) in
            print(user?.message ?? "")
        } onError: { (error) in
            print(error.localizedDescription)
        } onCompleted: {
            print("完成")
        } onDisposed: {
            print("销毁")
        }.disposed(by: rx.disposeBag)
        
        /// json
        UserNetManger.userInfo(usrid: "123").subscribe { (json) in
            print(json)
        } onError: { (error) in
            print(error.localizedDescription)
        } onCompleted: {
            print("完成")
        } onDisposed: {
            print("销毁")
        }.disposed(by: rx.disposeBag)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 字典转模型
    func toModel<T>(_ type: T.Type, value: Any?) -> T? where T: Decodable {
        guard let value = value else { return nil }
        return toModel(type, value: value)
    }
    /// 字典转模型
    func toModel<T>(_ type: T.Type, value: Any) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
        return try? decoder.decode(type, from: data)
    }
    
}
struct UserInfo:Codable {
    var message:String
}

class UserNetManger:NetBaseManger{
    static func userInfo(usrid:String)->Observable<[String: Any]>{
        return request(parameters: ["id":usrid], url: "/ping", cacheID: "/ping", method: .get)
    }
}

class NetBaseManger{
    static func request(parameters:[String:Any],url:String,cacheID:String,method:CTNetRequestMethod = .post)->Observable<[String: Any]>{
        let observable: Observable<[String: Any]> = Observable.create { observable in
            CTNet.request(url: url, method: method, parameters: [:], level: .high, cacheID: cacheID) { (jsonDict) in
                if var myJsonDict = jsonDict{
                    myJsonDict["isCache"] = true
                    observable.onNext(myJsonDict)
                }
            } netCallBack: { (jsonDict, error) in
                if let _error = error{
                    let myError = NSError(domain: _error.msg, code: _error.code, userInfo: nil)
                    observable.onError(myError)
                }else{
                    if let myJsonDict = jsonDict{
                        observable.onNext(myJsonDict)
                    }else{
                        let myError = NSError(domain: "data is error", code: -1300, userInfo: nil)
                        observable.onError(myError)
                    }
                }
            }
            return Disposables.create()
        }
        return observable
    }
}

//
//  ViewController.swift
//  CTNet
//
//  Created by tliens on 11/30/2020.
//  Copyright (c) 2020 tliens. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import CTNet


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CTNetConfigure.shared.port = ":8080"
//        CTNetConfigure.shared.host = "http://192.168.11.147"
//        CTNetConfigure.shared.timeout = 20
//        CTNetConfigure.shared.HTTPEvaluators = ["192.168.11.147"]
//
//        /// codable
//        UserNetManger.userInfo(usrid: "123").map { (json) -> UserInfo? in
//            return (self.toModel(UserInfo.self, value: json))
//        }.subscribe { (user) in
//            print(user?.message ?? "")
//        } onError: { (error) in
//            print(error.localizedDescription)
//        } onCompleted: {
//            print("完成")
//        } onDisposed: {
//            print("销毁")
//        }.disposed(by: rx.disposeBag)
//
//        /// json
//        UserNetManger.userInfo(usrid: "123").subscribe { (json) in
//            print(json)
//        } onError: { (error) in
//            print(error.localizedDescription)
//        } onCompleted: {
//            print("完成")
//        } onDisposed: {
//            print("销毁")
//        }.disposed(by: rx.disposeBag)
        
        CTNetAPICache.shared.clear()
        CTNetAPICache.shared.set(id: "qqqqwdesq", dict: ["aaaaa":1])
        CTNetAPICache.shared.set(id: "qqqasqscq22", dict: ["aaaaa":2])


        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


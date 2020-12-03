//
//  ViewController.swift
//  CTNet
//
//  Created by tliens on 11/30/2020.
//  Copyright (c) 2020 tliens. All rights reserved.
//

import UIKit
import CTNet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CTNetConfigure.shared.port = ":8080"
        CTNetConfigure.shared.host = "http://192.168.11.147"
        CTNetConfigure.shared.timeout = 20
        CTNetConfigure.shared.HTTPEvaluators = ["192.168.11.147"]
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct NetManger{

//    static func userInfo(usrid:String)->Single<[String: Any]?>{
//        let single: Single<[String: Any]?> = Single.create { single in
//            CTNet.request(url: "/ping", method: .get, parameters: [:]) { (jsonDict, error) in
//                if let _error = error{
//                    let myError = NSError(domain: _error.msg, code: _error.code, userInfo: nil)
//                    single(.error(myError))
//                }else{
//                    single(.success(jsonDict))
//                }
//            }
//            return Disposables.create()
//        }
//        return single
//    }
 
}

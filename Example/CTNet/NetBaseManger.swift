//
//  NetBaseManger.swift
//  CTNet_Example
//
//  Created by 2020 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import CTNet

class NetBaseManger{
    ///cacheID 缓存ID，如果有缓存，则根据缓存ID拿取，没有返回空，同时也是本次缓存的ID
    static func request(url:String,
                        method:CTNetRequestMethod = .post,
                        parameters:[String:Any],
                        cacheID:String)
    ->Observable<[String: Any]>{
        
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

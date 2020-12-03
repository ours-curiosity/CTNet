//
//  UserNet.swift
//  CTNet_Example
//
//  Created by 2020 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
class UserNetManger:NetBaseManger{
    
    enum URL:String{
        case userInfo = "/ping"
    }

    static func userInfo(usrid:String)->Observable<[String: Any]>{
        
        return request(url: URL.userInfo.rawValue,
                       method: .post,
                       parameters: ["id":usrid],
                       cacheID: "yesterday")
    }
    
}

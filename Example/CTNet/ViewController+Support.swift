//
//  ViewController+Support.swift
//  CTNet_Example
//
//  Created by 2020 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
/// 放到基础库中
extension ViewController{
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

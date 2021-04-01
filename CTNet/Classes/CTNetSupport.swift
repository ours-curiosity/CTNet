//
//  CTNetSupport.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
import CommonCrypto
extension String{
    var md5:String{
        return MD5(self)
    }

}
extension String {
    var netURL:URL?{
        return URL(string: self)
    }
    var localURL:URL?{
        return URL(fileURLWithPath: self, isDirectory: true)
    }
}
extension Dictionary{
    func toData()->Data?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        return data
    }
}
extension Data{
    func toDictionary()->Dictionary<String, Any>?{
        let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)
        let dict = json as? Dictionary<String, Any>
        return dict
    }
}

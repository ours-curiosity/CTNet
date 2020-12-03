//
//  CTNetSupport.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
import CommonCrypto
extension String{
    var  md5:String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        
        return String(format: hash as String)
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
        let dict = json as! Dictionary<String, Any>
        return dict
    }
}

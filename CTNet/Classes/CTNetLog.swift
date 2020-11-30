//
//  CTNetLog.swift
//  Net
//
//  Created by 2020 on 2020/11/30.
//

import Foundation
class CTNetLog{
    public static func log(_ items: Any...,
                    separator: String = " ",
                    terminator: String = "\n",
                    file: String = #file,
                    line: Int = #line,
                    method: String = #function)
    {
        if CTNetConfigure.shared.debug{
            print("CTNetLog ","\((file as NSString).lastPathComponent)[\(line)], \(method):", terminator: separator)
            var i = 0
            let j = items.count
            for a in items {
                i += 1
                print(" ",a, terminator:i == j ? terminator: separator)
            }
        }
    }
}

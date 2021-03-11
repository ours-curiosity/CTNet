//
//  CTNetAPICache.swift
//  CTNet
//
//  Created by 2020 on 2020/12/3.
//

import Foundation
@objcMembers
public class CTNetAPICache:NSObject{
    /// json的存储位置 后期可以根据不同的模块区分缓存位置 注意设置icloud防同步
    public let apiDirectory: String = CTNetConfigure.shared.cachePath
    public static let shared = CTNetAPICache()
    /// 单例模式初始化
    private override init(){
        super.init()
        checkDir()
    }
    private func checkDir(){
        var isDir: ObjCBool = true
        let isExists = FileManager.default.fileExists(atPath: self.apiDirectory, isDirectory: &isDir)
        if !isExists {
            try? FileManager.default.createDirectory(atPath: self.apiDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    /// 数据清空，当用户退出的时候
    public func clear(){
        if let url = apiDirectory.localURL{
            try? FileManager.default.removeItem(at: url)
        }
    }
    /// 清空某个数据 id
    public func clear(id:String){
        let name = id.md5
        let filePath = apiDirectory + name
        if let url = filePath.localURL{
            try? FileManager.default.removeItem(at: url)
        }
    }
    /// 获取接口数据
    public func get(id:String)->[String:Any]?{
        let name = id.md5
        let filePath = apiDirectory + name
        if let url = filePath.localURL{
            if let data = try? Data(contentsOf: url){
                return data.toDictionary()
            }
        }
        return nil
    }
    /// 缓存接口数据
    public func set(id:String,dict:[String:Any]){
        checkDir()
        let name = id.md5
        let filePath = apiDirectory + name
        let data = dict.toData()
        if let url = filePath.localURL{
            try? data?.write(to: url)
        }
    }
}


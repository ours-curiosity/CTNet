# CTNet

[![CI Status](https://img.shields.io/travis/tliens/CTNet.svg?style=flat)](https://travis-ci.org/tliens/CTNet)
[![Version](https://img.shields.io/cocoapods/v/CTNet.svg?style=flat)](https://cocoapods.org/pods/CTNet)
[![License](https://img.shields.io/cocoapods/l/CTNet.svg?style=flat)](https://cocoapods.org/pods/CTNet)
[![Platform](https://img.shields.io/cocoapods/p/CTNet.svg?style=flat)](https://cocoapods.org/pods/CTNet)

这是一个可以指定缓存、重试、优先级的轻量级网络库，基于Alamofire，容易扩展。

建议配合rx使用，Demo中展示了使用rx的优美指出。

也可以不用rx，因为本身和rx没有什么关系。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 5.0+

## Installation

CTNet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CTNet'
```

## Author

tliens, maninios@163.com

## License

CTNet is available under the MIT license. See the LICENSE file for more info.
## 使用
CTNetConfigure 是CTNet的配置中心，可以之指定如下内容：

- 端口
- host
- 超市时长
- 重试次数
- 是否自动缓存
- 最大并发数
- header自定义
- ssl赦免名单
- 缓存位置

CTNet 是整个请求的入口，可以指定以下内容

CTNetTask 是请求的具体任务，是Operation的子类，意味着，你可以轻易的使用OperationQueue对他进行管理。

具体查看Demo

建议同RxSwift一起使用
```
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
        
```

## NetBaseManger

```
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

```



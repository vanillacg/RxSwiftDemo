# RxCocoa URLSession

### 一、请求网络数据

### 1，通过 rx.response 请求数据

```swift
//创建URL对象
let urlString = "https://www.douban.com/j/app/radio/channels"
let url = URL(string:urlString)
//创建请求对象
let request = URLRequest(url: url!)
 
//创建并发起请求
URLSession.shared.rx.response(request: request).subscribe(onNext: {
    (response, data) in
    //数据处理
    let str = String(data: data, encoding: String.Encoding.utf8)
    print("返回的数据是：", str ?? "")
}).disposed(by: disposeBag)
```

```swift
extension Reactive where Base : URLSession {

    /**
    Observable sequence of responses for URL request.
    
    Performing of request starts after observer is subscribed and not after invoking this method.
    
    **URL requests will be performed per subscribed observer.**
    
    Any error during fetching of the response will cause observed sequence to terminate with error.
    
    - parameter request: URL request.
    - returns: Observable sequence of URL responses.
    */
    public func response(request: URLRequest) -> RxSwift.Observable<(response: HTTPURLResponse, data: Data)>

    /**
    Observable sequence of response data for URL request.
    
    Performing of request starts after observer is subscribed and not after invoking this method.
    
    **URL requests will be performed per subscribed observer.**
    
    Any error during fetching of the response will cause observed sequence to terminate with error.
    
    If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
    will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
    
    - parameter request: URL request.
    - returns: Observable sequence of response data.
    */
    public func data(request: URLRequest) -> RxSwift.Observable<Data>

    /**
    Observable sequence of response JSON for URL request.
    
    Performing of request starts after observer is subscribed and not after invoking this method.
    
    **URL requests will be performed per subscribed observer.**
    
    Any error during fetching of the response will cause observed sequence to terminate with error.
    
    If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
    will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
    
    If there is an error during JSON deserialization observable sequence will fail with that error.
    
    - parameter request: URL request.
    - returns: Observable sequence of response JSON.
    */
    public func json(request: URLRequest, options: JSONSerialization.ReadingOptions = []) -> RxSwift.Observable<Any>

    /**
    Observable sequence of response JSON for GET request with `URL`.
     
    Performing of request starts after observer is subscribed and not after invoking this method.
    
    **URL requests will be performed per subscribed observer.**
    
    Any error during fetching of the response will cause observed sequence to terminate with error.
    
    If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
    will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
    
    If there is an error during JSON deserialization observable sequence will fail with that error.
    
    - parameter url: URL of `NSURLRequest` request.
    - returns: Observable sequence of response JSON.
    */
    public func json(url: URL) -> RxSwift.Observable<Any>
}

```

### 二、手动发起请求、取消请求

```swift
//创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
         
        //发起请求按钮点击
        startBtn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.data(request: request)
                    .takeUntil(self.cancelBtn.rx.tap) //如果“取消按钮”点击则停止请求
            }
            .subscribe(onNext: {
                data in
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：", str ?? "")
            }, onError: { error in
                print("请求失败！错误原因：", error)
            }).disposed(by: disposeBag)
```

### 三、将结果转为 JSON 对象

```swift
//创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
            
        btn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.data(request: request)
        }.subscribe(onNext: { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print("json:\(json!)")
            }).disposed(by: disposeBag)
```

在订阅前就进行转换也是可以的：

```swift
btn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.data(request: request)
        }.map({ data in
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print("json:\(json!)")
            return json
        }).subscribe(onNext: { data in
                print(data)
            }).disposed(by: disposeBag)
```

还有更简单的方法，就是直接使用 **RxSwift** 提供的 **rx.json** 方法去获取数据，它会直接将结果转成 **JSON** 对象。
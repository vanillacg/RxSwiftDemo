# RxSwift Driver

#### 基本介绍

（1）**Driver** 可以说是最复杂的 **trait**，它的目标是提供一种简便的方式在 **UI** 层编写响应式代码。

（2）如果我们的序列满足如下特征，就可以使用它：

- 不会产生 **error** 事件
- 一定在主线程监听（**MainScheduler**）
- 共享状态变化（**shareReplayLatestWhileConnected**）

#### 为什么要使用 Driver?

（1）**Driver** 最常使用的场景应该就是需要用序列来驱动应用程序的情况了，比如：

- 通过 **CoreData** 模型驱动 **UI**
- 使用一个 **UI** 元素值（绑定）来驱动另一个 **UI** 元素值

（2）与普通的操作系统驱动程序一样，如果出现序列错误，应用程序将停止响应用户输入。

（3）在主线程上观察到这些元素也是极其重要的，因为 **UI** 元素和应用程序逻辑通常不是线程安全的。

（4）此外，使用构建 **Driver** 的可观察的序列，它是共享状态变化。

```swift
    lazy var testLabel : UILabel = {
        let testLabel = UILabel()
           testLabel.frame = CGRect(x: 0.0, y: 350.0, width: 80.0, height: 60.0)
           testLabel.backgroundColor = UIColor.white
        testLabel.textColor = .black
           return testLabel
       }()
    lazy var testLabel1 : UILabel = {
     let testLabel = UILabel()
        testLabel.frame = CGRect(x: 100.0, y: 350.0, width: 280.0, height: 60.0)
        testLabel.backgroundColor = UIColor.white
     testLabel.textColor = .green
        return testLabel
    }()
    
   private lazy var textview: UITextView = {
       let tf = UITextView.init(frame: CGRect(x: 0.0, y: 250, width: 100, height: 50))
       tf.textColor = .red
       
       return tf
      }()

 func fetchData(_ query: String?) -> Observable<String> {
            print("开始请求网络 \(Thread.current)")
            return Observable.create { observer -> Disposable in
                if query == "11" {
                                observer.onError(NSError.init(domain: "", code: 10010, userInfo: nil))
                            }
                            DispatchQueue.global().async {
                                print("发送信号之前: \(Thread.current)")
                                observer.onNext("发送的内容:\(String(describing: query))")
                                observer.onCompleted()
                }
                return Disposables.create()
            }
        }
        
        let results = textview.rx.text
            .throttle(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { query in
                fetchData(query).observeOn(MainScheduler.instance)
            }
            
        
        results.map { "\($0.count)"}
            .bind(to: testLabel.rx.text)
        .disposed(by: disposebag)
        
        results.bind(to: testLabel1.rx.text)
        .disposed(by: disposebag)
```

模拟一个网络请求的方法（返回得到的是一个序列），然后利用`UITextField`输入的内容，请求网络，返回得到的请求数据（这里假装请求了网络），然后将这个值发送出去。

这里结果result信号 订阅了两次

```swift
开始请求网络 <NSThread: 0x600000c9de40>{number = 1, name = main}
开始请求网络 <NSThread: 0x600000c9de40>{number = 1, name = main}
发送信号之前: <NSThread: 0x600000cd1c00>{number = 3, name = (null)}
发送信号之前: <NSThread: 0x600000c34fc0>{number = 9, name = (null)}
开始请求网络 <NSThread: 0x600000c9de40>{number = 1, name = main}
Fatal error: Binding error: Error Domain= Code=10010 "(null)": file /Users/chenguang/Desktop/CG/swift/LearnApps/muke/CGMK/Pods/RxCocoa/RxCocoa/RxCocoa.swift, line 153
2020-01-15 16:21:15.627171+0800 CGMK[93357:15953192] Fatal error: Binding error: Error Domain= Code=10010 "(null)": file /Users/chenguang/Desktop/CG/swift/LearnApps/muke/CGMK/Pods/RxCocoa/RxCocoa/RxCocoa.swift, line 153
```

三个问题

1. textField 内容改变一次 这里会发出两次信号,同时发出两次网络请求
2. 当textfiled 输入内容为11时, 代码crash 当前的result信号无法处理error
3. 从第二次订阅的时候打印的线程可以看出来，网络请求完数据，订阅到数据还在子线程，如果在这里面进行`UI`刷新的话，会出现问题。

```swift
 let results = textview.rx.text
            .throttle(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { query in
                fetchData(query)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn("错误事件")
            }.share(replay: 1, scope: .whileConnected)
```

代码用observeOn(MainScheduler.instance) , catchErrorJustReturn("错误事件"), share(replay: 1, scope: .whileConnected) 修复上述三个问题

 

#### RxSwift 中提供了Driver来解决问题

```swift
let tfDriver = textview.rx.text.orEmpty.asDriver()
        let results = tfDriver
            .throttle(RxTimeInterval.microseconds(300))
            .flatMapLatest { query in
                fetchData(query)
                .asDriver(onErrorJustReturn: "错误事件")
            }
        
        results.map { "\($0.count)"}
            .drive(testLabel.rx.text)
        .disposed(by: disposebag)

        results.drive(testLabel1.rx.text)
        .disposed(by: disposebag)
```

#### Driver源码

```swift
extension ControlProperty {
    /// Converts `ControlProperty` to `Driver` trait.
    ///
    /// `ControlProperty` already can't fail, so no special case needs to be handled.
    public func asDriver() -> Driver<Element> {
        return self.asDriver { _ -> Driver<Element> in  #block1
            #if DEBUG
                rxFatalError("Somehow driver received error from a source that shouldn't fail.")
            #else
                return Driver.empty()
            #endif
        }
    }
}


    }
```

asDriver() 是抽象方法由子类ObservableConvertibleType+Driver.swift 实现

asDriver() 将#block1 传递给子类做参数

```swift
  /**
    Converts observable sequence to `Driver` trait.
    
    - parameter onErrorRecover: Calculates driver that continues to drive the sequence in case of error.
    - returns: Driver trait.
    */
    public func asDriver(onErrorRecover: @escaping (_ error: Swift.Error) -> Driver<Element>) -> Driver<Element> {
        let source = self
            .asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
            .catchError { error in
                onErrorRecover(error).asObservable()
            }
        return Driver(source)
```

- observeOn 指定运行的线程到DriverSharingStrategy.scheduler 中

```swift
public struct DriverSharingStrategy: SharingStrategyProtocol {
    public static var scheduler: SchedulerType { return SharingScheduler.make() }
    public static func share<Element>(_ source: Observable<Element>) -> Observable<Element> {
        return source.share(replay: 1, scope: .whileConnected)
    }
}
```

在DriverSharingStrategy.scheduler 中 scheduler 由SharingScheduler 创建,SharingScheduler make 默认创建

MainScheduler 

```swift
public enum SharingScheduler {
    /// Default scheduler used in SharedSequence based traits.
    public private(set) static var make: () -> SchedulerType = { MainScheduler() }
}
```

所以Driver 中observeOn 指定运行的线程到DriverSharingStrategy.scheduler 中,就是指定到MainScheduler 中运行

-  .catchError { error in onErrorRecover(error).asObservable() }

```swift
 public func catchError(_ handler: @escaping (Swift.Error) throws -> Observable<Element>)
        -> Observable<Element> {
        return Catch(source: self.asObservable(), handler: handler)
    }
```

后面就是走catchError的逻辑当接受到错误信号后,将以OnNext(error)发送错误信号

- Driver(source)

```swift
public typealias Driver<Element> = SharedSequence<DriverSharingStrategy, Element>
```

```swift
public struct SharedSequence<SharingStrategy: SharingStrategyProtocol, Element> : SharedSequenceConvertibleType {
    let _source: Observable<Element>

    init(_ source: Observable<Element>) {
        self._source = SharingStrategy.share(source)
    }
}
```

```swift
public struct DriverSharingStrategy: SharingStrategyProtocol {
    public static var scheduler: SchedulerType { return SharingScheduler.make() }
    public static func share<Element>(_ source: Observable<Element>) -> Observable<Element> {
        return source.share(replay: 1, scope: .whileConnected)
    }
}
```

source初始化信号实现共享状态,解决了多次订阅的问题

#### 总结

1. 首先我们使用 **asDriver** 方法将 **ControlProperty** 转换为 **Driver**。

   ```swift
   let tfDriver = textview.rx.text.orEmpty.asDriver()
   ```

2. 接着我们可以用 **.asDriver(onErrorJustReturn: [])** 方法将任何 **Observable** 序列都转成 **Drive**

   ```swift
   let results = tfDriver
               .throttle(RxTimeInterval.microseconds(300))
               .flatMapLatest { query in
                   fetchData(query)
                   .asDriver(onErrorJustReturn: "错误事件")
               }
   ```

   因为我们知道序列转换为 **Driver** 要他满足 **3** 个条件：

   - 不会产生 **error** 事件
   - 一定在主线程监听（**MainScheduler**）
   - 共享状态变化（**shareReplayLatestWhileConnected**）

   而 **asDriver(onErrorJustReturn: [])** 相当于以下代码：

   ```swift
   let safeSequence = xs
        .observeOn(MainScheduler.instance) // 主线程监听
        .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
        .share(replay: 1, scope: .whileConnected)// 共享状态变化
        return Driver(raw: safeSequence) // 封装
   ```

   

3. 同时在 **Driver** 中，框架已经默认帮我们加上了 **shareReplayLatestWhileConnected**，所以我们也没必要再加上"**replay**"相关的语句了。

4. 最后记得使用 **drive** 而不是 **bindTo**

```swift
results.map { "\($0.count)"}
            .drive(testLabel.rx.text)
        .disposed(by: disposebag)
```


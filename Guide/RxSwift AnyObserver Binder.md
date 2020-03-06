# AnyObserver、Binder

## 一、观察者（Observer）介绍

观察者（**Observer**）的作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者。比如：

- 当我们点击按钮，弹出一个提示框。那么这个“弹出一个提示框”就是观察者 **Observer**
- 当我们请求一个远程的 **json** 数据后，将其打印出来。那么这个“打印 **json** 数据”就是观察者 **Observer**

[![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201801/2018011914534983507.png)](https://www.hangge.com/blog/cache/detail_1941.html#)



## 二、直接在 subscribe、bind 方法中创建观察者

### 1，在 subscribe 方法中创建

（1）创建观察者最直接的方法就是在 **Observable** 的 **subscribe** 方法后面描述当事件发生时，需要如何做出响应。

（2）比如下面的样例，观察者就是由后面的 **onNext**，**onError**，**onCompleted** 这些闭包构建出来的。

```swift
let observable = Observable.of("A", "B", "C")
          
observable.subscribe(onNext: { element in
    print(element)
}, onError: { error in
    print(error)
}, onCompleted: {
    print("completed")
})
```

运行结果如下：

[![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201801/2018011920465214855.png)](https://www.hangge.com/blog/cache/detail_1941.html#)

### 2，在 bind 方法中创建

（1）下面代码我们创建一个定时生成索引数的 **Observable** 序列，并将索引数不断显示在 **label** 标签上：

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
         
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
 
        observable
            .map { "当前索引数：\($0 )"}
            .bind { [weak self](text) in
                //收到发出的索引数后显示到label上
                self?.label.text = text
            }
            .disposed(by: disposeBag)
    }
}
```

```swift
    /**
    Subscribes an element handler to an observable sequence.
    In case error occurs in debug mode, `fatalError` will be raised.
    In case error occurs in release mode, `error` will be logged.

    - parameter onNext: Action to invoke for each element in the observable sequence.
    - returns: Subscription object used to unsubscribe from the observable sequence.
    */
    public func bind(onNext: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext, onError: { error in
            rxFatalErrorInDebug("Binding error: \(error)")
        })
    }

```

（2）运行结果如下：

[![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201801/2018012009284156168.png)](https://www.hangge.com/blog/cache/detail_1941.html#)



## 三、使用 AnyObserver 创建观察者

**AnyObserver** 可以用来描叙任意一种观察者。

### 1，配合 subscribe 方法使用

比如上面第一个样例我们可以改成如下代码：

```swift
//观察者
let observer: AnyObserver<String> = AnyObserver { (event) in
    switch event {
    case .next(let data):
        print(data)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
}
 
let observable = Observable.of("A", "B", "C")
observable.subscribe(observer)
```



### 2，配合 bindTo 方法使用

bindTo源码

```swift
/** 内部有个for in  可绑定多个Observer
     Creates new subscription and sends elements to observer(s).
     In this form, it's equivalent to the `subscribe` method, but it better conveys intent, and enables
     writing more consistent binding code.
     - parameter to: Observers to receives events.
     - returns: Disposable object that can be used to unsubscribe the observers.
     */
    private func bind<Observer: ObserverType>(to observers: [Observer]) -> Disposable where Observer.Element == Element {
        return self.subscribe { event in
            observers.forEach { $0.on(event) }
        }
    }
```

也可配合 **Observable** 的数据绑定方法（**bindTo**）使用。比如上面的第二个样例我可以改成如下代码：

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
         
        //观察者
        let observer: AnyObserver<String> = AnyObserver { [weak self] (event) in
            switch event {
            case .next(let text):
                //收到发出的索引数后显示到label上
                self?.label.text = text
            default:
                break
            }
        }
         
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
}
```

运行结果如下：

[![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201801/2018012009284156168.png)](https://www.hangge.com/blog/cache/detail_1941.html#)



## 四、使用 Binder 创建观察者

### 1，基本介绍

（1）相较于 **AnyObserver** 的大而全，**Binder** 更专注于特定的场景。**Binder** 主要有以下两个特征：

- 不会处理错误事件
- 确保绑定都是在给定 **Scheduler** 上执行（默认 **MainScheduler**）

（2）一旦产生错误事件，在调试环境下将执行 **fatalError**，在发布环境下将打印错误信息。

### 2，使用样例

（1）在上面序列数显示样例中，**label** 标签的文字显示就是一个典型的 **UI** 观察者。它在响应事件时，只会处理 **next** 事件，而且更新 **UI** 的操作需要在主线程上执行。那么这种情况下更好的方案就是使用 **Binder**。

（2）上面的样例我们改用 **Binder** 会简单许多：

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
                 
        //观察者
        let observer: Binder<String> = Binder(label) { (view, text) in
            //收到发出的索引数后显示到label上
            view.text = text
        }
         
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
}
```

运行结果如下：

[![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201801/2018012009284156168.png)](https://www.hangge.com/blog/cache/detail_1941.html#)

### 附：Binder 在 RxCocoa 中的应用

（1）其实 **RxCocoa** 在对许多 **UI** 控件进行扩展时，就利用 **Binder** 将控件属性变成观查者，比如 **UIControl+Rx.swift** 中的 **isEnabled** 属性便是一个 **observer** ：

```swift
import RxSwift
import UIKit
 
extension Reactive where Base: UIControl {
     
    /// Bindable sink for `enabled` property.
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}
```



（2）因此我们可以将序列直接绑定到它上面。比如下面样例，**button** 会在可用、不可用这两种状态间交替变换（每隔一秒）。

  [![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201804/2018042818134057189.png)](https://www.hangge.com/blog/cache/detail_1941.html#)   [![原文:Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）](https://www.hangge.com/blog_uploads/201804/201804281813472160.png)](https://www.hangge.com/blog/cache/detail_1941.html#)

```swift
//Observable序列（每隔1秒钟发出一个索引数）
let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
observable
    .map { $0 % 2 == 0 }
    .bind(to: button.rx.isEnabled)
    .disposed(by: disposeBag)
```



## 五、自定义可绑定属性

有时我们想让 **UI** 控件创建出来后默认就有一些观察者，而不必每次都为它们单独去创建观察者。比如我们想要让所有的 **UIlabel** 都有个 **fontSize** 可绑定属性，它会根据事件值自动改变标签的字体大小。

### 方式一：通过对 UI 类进行扩展

（1）这里我们通过对 **UILabel** 进行扩展，增加了一个 **fontSize** 可绑定属性。

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
         
        //Observable序列（每隔0.5秒钟发出一个索引数）
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable
            .map { CGFloat($0) }
            .bind(to: label.fontSize) //根据索引数不断变放大字体
            .disposed(by: disposeBag)
    }
}
 
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
```


（2）运行结果如下，随着序列数的不断增长，标签文字也不断的变大。

[![原文:Swift - RxSwift的使用详解6（观察者2： 自定义可绑定属性）](https://www.hangge.com/blog_uploads/201801/2018012010510081287.png)](https://www.hangge.com/blog/cache/detail_1946.html#)[![原文:Swift - RxSwift的使用详解6（观察者2： 自定义可绑定属性）](https://www.hangge.com/blog_uploads/201801/2018012010510610894.png)](https://www.hangge.com/blog/cache/detail_1946.html#)

### 方式二：通过对 Reactive 类进行扩展

既然使用了 **RxSwift**，那么更规范的写法应该是对 **Reactive** 进行扩展。这里同样是给 **UILabel** 增加了一个 **fontSize** 可绑定属性。

（注意：这种方式下，我们绑定属性时要写成 **label.rx.fontSize**）

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
         
        //Observable序列（每隔0.5秒钟发出一个索引数）
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable
            .map { CGFloat($0) }
            .bind(to: label.rx.fontSize) //根据索引数不断变放大字体
            .disposed(by: disposeBag)
    }
}
 
extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
```



## 六、RxSwift 自带的可绑定属性（UI 观察者）

（1）其实 **RxSwift** 已经为我们提供许多常用的可绑定属性。比如 **UILabel** 就有 **text** 和 **attributedText** 这两个可绑定属性。

```swift
import RxSwift
import UIKit
 
extension Reactive where Base: UILabel {
     
    /// Bindable sink for `text` property.
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
 
    /// Bindable sink for `attributedText` property.
    public var attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
     
}
```


（2）那么上文那个定时显示索引数的样例，我们其实不需要自定义 **UI** 观察者，直接使用 **RxSwift** 提供的绑定属性即可。

```swift
import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
     
    @IBOutlet weak var label: UILabel!
     
    let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
         
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: label.rx.text) //收到发出的索引数后显示到label上
            .disposed(by: disposeBag)
    }
}
```


(3)运行结果如下：

[![原文:Swift - RxSwift的使用详解6（观察者2： 自定义可绑定属性）](https://www.hangge.com/blog_uploads/201801/2018012009284156168.png)](https://www.hangge.com/blog/cache/detail_1946.html#)


原文出自：[www.hangge.com](https://www.hangge.com/) 转载请保留原文链接：https://www.hangge.com/blog/cache/detail_1941.html
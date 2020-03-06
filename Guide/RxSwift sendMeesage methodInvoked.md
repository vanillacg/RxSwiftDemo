### RxSwift sendMeesage methodInvoked

- ### 1，sendMessage 与 methodInvoked 的区别

  （1）在之前的几篇文章中，我用到了 **methodInvoked** 这个 **Rx** 扩展方法，其作用是获取代理方法执行后产生的数据流。

  （2）除了 **methodInvoked** 外，还有个 **sentMessage** 方法也有同样的作用，它们间只有一个区别：

  - **sentMessage** 会在调用方法前发送值。
  - **methodInvoked** 会在调用方法后发送值。

  ### 2，实现原理

  （1）其原理简单说就是利用 **Runtime** 消息转发机制来转发代理方法。同时在调用返回值为空的代理方法的前后分别产生两种数据流。

  （2）比如最开始的代理为 **A**，然后我们把代理改为 **AProxy**，并把 **A** 设置为 **AProxy** 的 **_forwardToDelegate**。这样所有的代理方法将会变成到达 **AProxy**，接着 **AProxy** 对这些方法进行如下操作：

  - 首先调用 **sentMessage** 方法
  - 接着调用原代理方法 
  - 最后调用 **methodInvoked** 方法

  ## 二、使用样例

  ```swift
              let disposebag = DisposeBag()
      override func viewDidLoad() {
          super.viewDidLoad()
          self.rx.sentMessage(#selector(ViewController.viewWillAppear(_:))).subscribe(onNext: { x in
              print("sentMessage:\(x)")
              }).disposed(by: disposebag)
          self.rx.methodInvoked(#selector(ViewController.viewWillAppear(_:))).subscribe(onNext: { x in
              print("methodInvoked:\(x)")
              }).disposed(by: disposebag)
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          print("viewWillAppear:\(animated)")
          self.navigationController?.setNavigationBarHidden(true, animated: true)
          
      }
  
  ============ 
  console:
  sentMessage:[1]
  viewWillAppear:true
  methodInvoked:[1]
  ```

  Hook 自己的方法

```swift
    let disposebag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor = UIColor.white
        let recVC = CGHomeRecommendVC()
        recVC.title = "推荐"
        let freeVC = CGHomeFreeVC()
        freeVC.title = "免费课"
        let battleVC = CGHomeBattleVC()
        battleVC.title = "实战课"
        let jobVC = CGHomeJobVC()
        jobVC.title = "就业班"
        let columnVC = CGHomeColumnVC()
        columnVC.title = "专栏"
        let vcs = [recVC,freeVC,battleVC,jobVC,columnVC]
        let VCContainer = CGVCContainer(frame: view.bounds, parentVC : self)
        VCContainer.contentVCs = vcs
        view.addSubview(VCContainer)
        // Do any additional setup after loading the view.
        self.rx.sentMessage(#selector(CGHomeViewController.test(arg1:arg2:))).subscribe(onNext: { x in
            print("sentMessage:\(x)")
            }).disposed(by: disposebag)
        self.rx.methodInvoked(#selector(CGHomeViewController.test(arg1:arg2:))).subscribe(onNext: { x in
            print("methodInvoked:\(x)")
            }).disposed(by: disposebag)
        
        test(arg1: "xxxxxx", arg2: 2)
    }
    
    @objc dynamic func test(arg1: String, arg2: Int) {
        print("arg1:\(arg1) arg2:\(arg2)")
    }

=======
console:
sentMessage:[xxxxxx, 2]
arg1:xxxxxx arg2:2
methodInvoked:[xxxxxx, 2]
```



关于:@objc 和dynamic

但这只是故事的开始。Objective-C 和 Swift 在底层使用的是两套完全不同的机制，Cocoa 中的 Objective-C 对象是基于运行时的，它从骨子里遵循了 KVC (Key-Value Coding，通过类似字典的方式存储对象信息) 以及动态派发 (Dynamic Dispatch，在运行调用时再决定实际调用的具体实现)。而 Swift 为了追求性能，如果没有特殊需要的话，是不会在运行时再来决定这些的。也就是说，Swift 类型的成员或者方法在编译时就已经决定，而运行时便不再需要经过一次查找，而可以直接使用。

显而易见，这带来的问题是如果我们要使用 Objective-C 的代码或者特性来调用纯 Swift 的类型时候，我们会因为找不到所需要的这些运行时信息，而导致失败。解决起来也很简单，在 Swift 类型文件中，我们可以将需要暴露给 Objective-C 使用的任何地方 (包括类，属性和方法等) 的声明前面加上 `@objc` 修饰符。注意这个步骤只需要对那些不是继承自 `NSObject` 的类型进行，如果你用 Swift 写的 class 是继承自 `NSObject` 的话，Swift 会默认自动为所有的非 private 的类和成员加上 `@objc`。这就是说，对一个 `NSObject` 的子类，你只需要导入相应的头文件就可以在 Objective-C 里使用这个类了。

`@objc` 修饰符的另一个作用是为 Objective-C 侧重新声明方法或者变量的名字。虽然绝大部分时候自动转换的方法名已经足够好用 (比如会将 Swift 中类似 `init(name: String)` 的方法转换成 `-initWithName:(NSString *)name` 这样)，但是有时候我们还是期望 Objective-C 里使用和 Swift 中不一样的方法名或者类的名字，比如 Swift 里这样的一个类：

```swift
class 我的类: NSObject {
    func 打招呼(名字: String) {
        print("哈喽，\(名字)")
    }
}

我的类().打招呼("小明")
```

> 注：在 Swift 2.0 中，Apple 在从 Swift 导出头文件时引入了一个叫做 `SWIFT_CLASS_NAMED` 的宏来对原来 Swift 中的内容进行标记。这个宏使用 LLVM 的标记来对目标类的类型做出了限制，但是同时引入了不允许非 ascii 编码的问题。下面的代码在 Swift 1.x 环境下可以通过，但是在 Swift 2 中会导致 “Parameter of 'swift_name' attribute must be an ASCII identifier string” 的编译错误，这应该是 Swift 2.0 中的一个预期之外的倒退。笔者已经向 Apple 提交了 bug 报告。关于这个问题的更多信息，可以参考 [rdar://22737851](https://openradar.appspot.com/22737851) 和[这里](https://github.com/swifter-tips/Public-Issues/issues/37)的讨论。

Objective-C 的话是无法使用中文来进行调用的，因此我们**必须**使用 `@objc` 将其转为 ASCII 才能在 Objective-C 里访问：

```swift
    @objc(MyClass)
    class 我的类 {
        @objc(greeting:)
        func 打招呼(名字: String) {
            print("哈喽，\(名字)")
        }
    }
```

这样，我们在 Objective-C 里就能调用 `[[MyClass new] greeting:@"XiaoMing"]` 这样的代码了 (虽然比起原来一点都不好玩了)。另外，正如上面所说的以及在 [Selector](https://swifter.tips/selector/) 一节中所提到的，即使是 `NSObject` 的子类，Swift 也不会在被标记为 `private` 的方法或成员上自动加 `@objc`，以保证尽量不使用动态派发来提高代码执行效率。如果我们确定使用这些内容的动态特性的话，我们需要手动给它们加上 `@objc` 修饰。

但是需要注意的是，添加 `@objc` 修饰符并不意味着这个方法或者属性会变成动态派发，Swift 依然可能会将其优化为静态调用。如果你需要和 Objective-C 里动态调用时相同的运行时特性的话，你需要使用的修饰符是 `dynamic`。一般情况下在做 app 开发时应该用不上，但是在施展一些像动态替换方法或者运行时再决定实现这样的 "黑魔法" 的时候，我们就需要用到 `dynamic` 修饰符了。在 [KVO](https://swifter.tips/kvo/) 一节中，我们提到了一个关于使用 `dynamic` 的实例。
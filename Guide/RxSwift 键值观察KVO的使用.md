### RxSwift 键值观察KVO的使用

### 1，KVO 介绍

- **KVO**（键值观察）是一种 **Objective-C** 的回调机制，全称为：**key-value-observing**。
- 该机制简单来说就是在某个对象注册监听者后，当被监听的对象发生改变时，对象会发送一个通知给监听者，以便监听者执行回调操作。

### 2，RxSwift 中的 KVO

**RxCocoa** 提供了 **2** 个可观察序列 **rx.observe** 和 **rx.observeWeakly**，它们都是对 **KVO** 机制的封装，二者的区别如下。

（1）性能比较

- **rx.observe** 更加高效，因为它是一个 **KVO** 机制的简单封装。
- **rx.observeWeakly** 执行效率要低一些，因为它要处理对象的释放防止弱引用（对象的 **dealloc** 关系）。

（2）使用场景比较

- 在可以使用 **rx.observe** 的地方都可以使用 **rx.observeWeakly**。
- 使用 **rx.observe** 时路径只能包括 **strong** 属性，否则就会有系统崩溃的风险。而 **rx.observeWeakly** 可以用在 **weak** 属性上

## 二、使用样例

**注意：**

- 监听的属性需要有 **dynamic** 修饰符。
- 本样例需要使用 **rx.observeWeakly**，不能用 **rx.observe**，否则会造成循环引用，引起内存泄露。

```swift
//定时器（1秒执行一次）
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                //每次给字符串尾部添加一个感叹号
                self.message.append("!")
            }).disposed(by: disposeBag)
         
        //监听message变量的变化
        _ = self.rx.observeWeakly(String.self, "message")
            .subscribe(onNext: { (value) in
            print(value ?? "")
        })
==========
console:
hangge.com
hangge.com!
hangge.com!!
hangge.com!!!
hangge.com!!!!
hangge.com!!!!!
hangge.com!!!!!!
hangge.com!!!!!!!
hangge.com!!!!!!!!
hangge.com!!!!!!!!!
hangge.com!!!!!!!!!!
```

```swift
        self.barImageView = self.navigationController?.navigationBar.subviews.first

        self.navigationController?.navigationBar.barTintColor = .orange
        
        _ = self.tableView.rx.observe(CGPoint.self, "contentOffset").subscribe(onNext: { [weak self] offset in
            var delta = offset!.y/CGFloat(64) + 1
            delta = CGFloat.maximum(delta, 0)
            self?.barImageView?.alpha = CGFloat.maximum(delta, 1)
        })
```


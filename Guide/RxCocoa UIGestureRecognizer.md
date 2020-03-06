## RxCocoa UIGestureRecognizer

**RxCocoa** 同样对 **UIGestureRecognizer** 进行了扩展，并增加相关的响应方法。下面以滑动手势为例，其它手势用法也是一样的。

```swift
let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        swipe.rx.event.bind(onNext: { recognizer in
            let p = recognizer.location(in: recognizer.view)
            self.testLabel.text = "横坐标\(p.x)"
            self.testLabel1.text = "纵坐标\(p.y)"
        })
```

```swift
extension Reactive where Base: UIGestureRecognizer {
    
    /// Reactive wrapper for gesture recognizer events.
    public var event: ControlEvent<Base> {
        let source: Observable<Base> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureRunningOnMainThread()

            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            let observer = GestureTarget(control) { control in
                observer.on(.next(control))
            }
            
            return observer
        }.takeUntil(deallocated)
        
        return ControlEvent(events: source)
    }
    
}
```


# RxCocoa UILabel UITextField UITextView

### UILabel

```swift
let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer.map {
            String(format: "%d", arguments: [$0])
            }.bind(to: testLabel.rx.text).disposed(by: disposebag)
```

在UILabel+Rx.swift 中, text 继承自Binder

```swift
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

Binder 实现ObserverType协议, 做完观察者, Binder中实现asObserver()  返回AnyObserver 即可以从 Binder 转换成AnyObserver

```swift
public struct Binder<Value>: ObserverType {
    public typealias Element = Value
    
    private let _binding: (Event<Value>) -> Void

    /// Initializes `Binder`
    ///
    /// - parameter target: Target object.
    /// - parameter scheduler: Scheduler used to bind the events.
    /// - parameter binding: Binding logic.
    public init<Target: AnyObject>(_ target: Target, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target

        self._binding = { event in
            switch event {
            case .next(let element):
                _ = scheduler.schedule(element) { element in
                    if let target = weakTarget {
                        binding(target, element)
                    }
                    return Disposables.create()
                }
            case .error(let error):
                bindingError(error)
            case .completed:
                break
            }
        }
    }

    /// Binds next element to owner view as described in `binding`.
    public func on(_ event: Event<Value>) {
        self._binding(event)
    }

    /// Erases type of observer.
    ///
    /// - returns: type erased observer.
    public func asObserver() -> AnyObserver<Value> {
        return AnyObserver(eventHandler: self.on)
    }
}
```



### UITextField

在UITextField+Rx 中可以看到text 是继承自ControlProperty, ControlProperty遵从ControlPropertyType, ControlPropertyType用遵从ObservableType, ObserverType协议

因此textField.rx.text 既可以是观察者也可以是被观察者

**.orEmpty** 可以将 **String?** 类型的 **ControlProperty** 转成 **String**

```swift
//转换成可观察序列
textField.rx.text.orEmpty.asObservable().subscribe(onNext: {
            self.testLabel.text = $0
            }).disposed(by: disposebag)

textField.rx.text.changed.subscribe(onNext: {
        self.testLabel1.text = $0
        }).disposed(by: disposebag)
```

```swift
extension Reactive where Base: UITextField {
    /// Reactive wrapper for `text` property.
    public var text: ControlProperty<String?> {
        return value
    }
    
    /// Reactive wrapper for `text` property.
    public var value: ControlProperty<String?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.text
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input 
                // when IME input method is used.
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
    
    /// Bindable sink for `attributedText` property.
    public var attributedText: ControlProperty<NSAttributedString?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.attributedText
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input
                // when IME input method is used.
                if textField.attributedText != value {
                    textField.attributedText = value
                }
            }
        )
    }
    
}
```

```swift
public protocol ControlPropertyType : ObservableType, ObserverType {

    /// - returns: `ControlProperty` interface
    func asControlProperty() -> ControlProperty<Element>
}
```



#### 将内容绑定到其他控件上

- 我们将第一个 **textField** 里输入的内容实时地显示到第二个 **textField** 中。
- 同时 **label** 中还会实时显示当前的字数。
- 最下方的“**提交**”按钮会根据当前的字数决定是否可用（字数超过 **5** 个字才可用）

```swift
let tfInput = textField.rx.text.orEmpty.asDriver()
        tfInput.drive(textField1.rx.text)
            .disposed(by: disposebag)
        tfInput.map { (i) -> String in
            return "当前字数:\(i.count)"
            }.drive(testLabel.rx.text).disposed(by: disposebag)
        
        tfInput.map {
            $0.count > 3
            }.drive(btn.rx.isEnabled).disposed(by: disposebag)
```

ControlProperty 满足driver三条件

```swift
extension ControlProperty {
    /// Converts `ControlProperty` to `Driver` trait.
    ///
    /// `ControlProperty` already can't fail, so no special case needs to be handled.
    public func asDriver() -> Driver<Element> {
        return self.asDriver { _ -> Driver<Element> in
            #if DEBUG
                rxFatalError("Somehow driver received error from a source that shouldn't fail.")
            #else
                return Driver.empty()
            #endif
        }
    }
}
```

#### 同时监听多个textfield内容的变化

```swift
Observable.combineLatest(textField.rx.text.orEmpty, textField1.rx.text.orEmpty) { (s1, s2) -> String in
            return "r输入的好吗是\(s1), \(s2)"
            }
            .bind(to: testLabel.rx.text)
            .disposed(by: disposebag)
```

#### 事件监听

通过 **rx.controlEvent** 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 **UI** 控件都有的 **touch** 事件外，输入框还有如下几个独有的事件：

- **editingDidBegin**：开始编辑（开始输入内容）
- **editingChanged**：输入内容发生改变
- **editingDidEnd**：结束编辑
- **editingDidEndOnExit**：按下 **return** 键结束编辑
- **allEditingEvents**：包含前面的所有编辑相关事件

```swift
textField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asDriver()
            .map{ "开始或结束" }
            .drive(testLabel.rx.text)
            .disposed(by: disposebag)
```


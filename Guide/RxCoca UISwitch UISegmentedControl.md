# RxCoca UISwitch UISegmentedControl

UISwitch

```swift
let o = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        o.map({ $0%2 == 0
        }).bind(to: switchTest.rx.isOn).disposed(by: disposebag)
```



```swift
extension Reactive where Base: UISwitch {

    /// Reactive wrapper for `isOn` property.
    public var isOn: ControlProperty<Bool> {
        return value
    }

    /// Reactive wrapper for `isOn` property.
    ///
    /// ⚠️ Versions prior to iOS 10.2 were leaking `UISwitch`'s, so on those versions
    /// underlying observable sequence won't complete when nothing holds a strong reference
    /// to `UISwitch`.
    public var value: ControlProperty<Bool> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { uiSwitch in
                uiSwitch.isOn
            }, setter: { uiSwitch, value in
                uiSwitch.isOn = value
            }
        )
    }
    
}
```

UISegmentedControl

```swift
 override func viewDidLoad() {
        //创建一个当前需要显示的图片的可观察序列
        let showImageObservable: Observable<UIImage> =
            segmented.rx.selectedSegmentIndex.asObservable().map {
                let images = ["js.png", "php.png", "react.png"]
                return UIImage(named: images[$0])!
        }
         
        //把需要显示的图片绑定到 imageView 上
        showImageObservable.bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
```





```swift
extension Reactive where Base: UISegmentedControl {
    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }
    
    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var value: ControlProperty<Int> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { segmentedControl in
                segmentedControl.selectedSegmentIndex
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegmentIndex = value
            }
        )
    }
    
    /// Reactive wrapper for `setEnabled(_:forSegmentAt:)`
    public func enabledForSegment(at index: Int) -> Binder<Bool> {
        return Binder(self.base) { segmentedControl, segmentEnabled -> Void in
            segmentedControl.setEnabled(segmentEnabled, forSegmentAt: index)
        }
    }
    
    /// Reactive wrapper for `setTitle(_:forSegmentAt:)`
    public func titleForSegment(at index: Int) -> Binder<String?> {
        return Binder(self.base) { segmentedControl, title -> Void in
            segmentedControl.setTitle(title, forSegmentAt: index)
        }
    }
    
    /// Reactive wrapper for `setImage(_:forSegmentAt:)`
    public func imageForSegment(at index: Int) -> Binder<UIImage?> {
        return Binder(self.base) { segmentedControl, image -> Void in
            segmentedControl.setImage(image, forSegmentAt: index)
        }
    }

}
```


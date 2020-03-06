# RxCocoa  UIActivityIndicatorView UIApplication

### UIActivityIndicatorView

```swift
switchTest.rx.isOn.bind(to: activityView.rx.isAnimating)
        .disposed(by: disposebag)
```

```swift
extension Reactive where Base: UIActivityIndicatorView {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

}
```

### UIApplication

**RxSwift** 对 **UIApplication** 增加了一个名为 **isNetworkActivityIndicatorVisible** 绑定属性，我们通过它可以设置是否显示联网指示器（网络请求指示器）。

```swift
switchTest.rx.isOn.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
        .disposed(by: disposebag)
```

```swift
    extension Reactive where Base: UIApplication {
        
        /// Bindable sink for `networkActivityIndicatorVisible`.
        public var isNetworkActivityIndicatorVisible: Binder<Bool> {
            return Binder(self.base) { application, active in
                application.isNetworkActivityIndicatorVisible = active
            }
        }
    }
```


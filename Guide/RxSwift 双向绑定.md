# RxSwift 双向绑定

有时候我们需要实现双向绑定。比如将控件的某个属性值与 **ViewModel** 里的某个 **Subject** 属性进行双向绑定：

- 这样当 **ViewModel** 里的值发生改变时，可以同步反映到控件上。
- 而如果对控件值做修改，**ViewModel** 那边值同时也会发生变化。



## 一、简单的双向绑定

1）页面上方是一个文本输入框，用于填写用户名。它与 **VM** 里的 **username** 属性做双向绑定。

（2）下方的文本标签会根据用户名显示对应的用户信息。（只有 **hangge** 显示管理员，其它都是访客）

```swift
class CGFreeVM: CGMKViewModel {
    let user = Variable("guest")
    lazy var userInfo = {
        return self.user.asObservable().map { $0 == "cg" ? "管理员" : "普通访客"
        }
        .share(replay: 1, scope: .whileConnected)
    }()
}
```

```swift
				var vm = CGFreeVM()
				//用户名与textField双向绑定
        vm.user.asObservable().bind(to: textField.rx.text).disposed(by: disposebag)
        textField.rx.text.orEmpty.bind(to: vm.user).disposed(by: disposebag)
        //将用户信息绑定到label上
        vm.userInfo.bind(to: testLabel.rx.text).disposed(by: disposebag)
```


# RxCocoa UISlider UIStepper 

UIStepper 控制 UISlider 进度条

```swift
stepper.rx.value.map {
            Float($0)
            }.bind(to: slider.rx.value).disposed(by: disposebag)
```



```swift
extension Reactive where Base: UISlider {
    
    /// Reactive wrapper for `value` property.
    public var value: ControlProperty<Float> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { slider in
                slider.value
            }, setter: { slider, value in
                slider.value = value
            }
        )
    }
    
}
```

```swift
extension Reactive where Base: UIStepper {
    
    /// Reactive wrapper for `value` property.
    public var value: ControlProperty<Double> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { stepper in
                stepper.value
            }, setter: { stepper, value in
                stepper.value = value
            }
        )
    }

    /// Reactive wrapper for `stepValue` property.
    public var stepValue: Binder<Double> {
        return Binder(self.base) { stepper, value in
            stepper.stepValue = value
        }
    }
    
}
```


//
//  CGHomeFreeVC.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CGFreeVM: CGMKViewModel {
    let user = Variable("guest")
    lazy var userInfo = {
        return self.user.asObservable().map { $0 == "cg" ? "管理员" : "普通访客"
        }
        .share(replay: 1, scope: .whileConnected)
    }()
}

class CGHomeFreeVC: UIViewController {
    
    var disposebag = DisposeBag()
    
    
    
    lazy var btn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 200.0, y: 100.0, width: 100.0, height: 100.0)
        btn.backgroundColor = UIColor.white
//        btn.titleLabel?.textColor = UIColor.black
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        _ = btn.rx.tap.subscribe(onNext: { (x) in
            print(x)
        })
        btn .setTitleColor(UIColor.red, for: .disabled)
        return btn
    }()
    
    lazy var testLabel : UILabel = {
        let testLabel = UILabel()
           testLabel.frame = CGRect(x: 0.0, y: 350.0, width: 280, height: 60.0)
           testLabel.backgroundColor = UIColor.white
        testLabel.textColor = .black
           return testLabel
       }()
    lazy var testLabel1 : UILabel = {
     let testLabel = UILabel()
        testLabel.frame = CGRect(x: 0.0, y: 450.0, width: 280.0, height: 60.0)
        testLabel.backgroundColor = UIColor.white
     testLabel.textColor = .green
        return testLabel
    }()
    
   private lazy var textview: UITextView = {
       let tf = UITextView.init(frame: CGRect(x: 0.0, y: 250, width: 100, height: 50))
       tf.textColor = .red
       
       return tf
   }()
    
    private lazy var slider: UISlider = {
        let s = UISlider.init(frame: CGRect(x: 150, y: 250, width: 100, height: 50))
        s.minimumTrackTintColor = .red
        s.maximumTrackTintColor = .blue
        s.minimumValue = 0.1
        return s
    }()
    private lazy var stepper: UIStepper = {
        let s = UIStepper.init(frame: CGRect(x: 270, y: 250, width: 100, height: 50))
        return s
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField.init(frame: CGRect(x: 70.0, y: 10.0, width: 100, height: 50))
        tf.backgroundColor = UIColor.white
     tf.textColor = .red
     
     return tf
    }()
    
    private lazy var textField1: UITextField = {
        let tf = UITextField.init(frame: CGRect(x: 70.0, y: 70.0, width: 100, height: 50))
        tf.backgroundColor = UIColor.white
     tf.textColor = .green
     
     return tf
    }()
    lazy var switchTest : UISwitch = {
        let s = UISwitch.init(frame: CGRect(x: 20.0, y: 520.0, width: 100, height: 40))
        s.isOn = true
        s.onTintColor = .red
        return s
    }()
   
    lazy var btn1 : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50.0)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.textColor = UIColor.black
        btn.setTitleColor(UIColor.red, for: .highlighted)
        _ = btn.rx.tap.subscribe(onNext: { (x) in
            self.navigationController?.popViewController(animated: true)
        })
        btn .setTitleColor(UIColor.red, for: .disabled)
        return btn
    }()
    lazy var activityView : UIActivityIndicatorView = {
        let s = UIActivityIndicatorView.init(frame: CGRect(x: 150, y: 520.0, width: 100, height: 40))
        s.style = .whiteLarge
        s.startAnimating() 
        return s
    }()
    
    var vm = CGFreeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title? = "免费课"
        view.backgroundColor = UIColor.purple
        view.addSubview(btn)
        view.addSubview(btn1)
        view.addSubview(textview)
        view.addSubview(textField)
        view.addSubview(textField1)
        view.addSubview(testLabel)
        view.addSubview(testLabel1)
        view.addSubview(switchTest)
        view.addSubview(activityView)
        view.addSubview(slider)
        view.addSubview(stepper)
        
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        swipe.rx.event.bind(onNext: { recognizer in
            let p = recognizer.location(in: recognizer.view)
            self.testLabel.text = "横坐标\(p.x)"
            self.testLabel1.text = "纵坐标\(p.y)"
        })
        //        slider.rx.value.map {
//            Double($0)
//        }.bind(to: stepper.rx.stepValue)
//        .disposed(by: disposebag)
        
//        vm.user.asObservable().bind(to: textField.rx.text).disposed(by: disposebag)
//        textField.rx.text.orEmpty.bind(to: vm.user).disposed(by: disposebag)
//
//        vm.userInfo.bind(to: testLabel.rx.text).disposed(by: disposebag)
//        stepper.rx.value.map {
//            Float($0)
//            }.bind(to: slider.rx.value).disposed(by: disposebag)
//        let o = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        o.map({ $0%2 == 0
//        }).bind(to: switchTest.rx.isOn).disposed(by: disposebag)
//        func fetchData(_ query: String?) -> Observable<String> {
        
//        switchTest.rx.isOn.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
//        .disposed(by: disposebag)
//            print("开始请求网络 \(Thread.current)")
//            return Observable.create { observer -> Disposable in
//                if query == "11" {
//                                observer.onError(NSError.init(domain: "", code: 10010, userInfo: nil))
//                            }
//                            DispatchQueue.global().async {
//                                print("发送信号之前: \(Thread.current)")
//                                observer.onNext("发送的内容:\(String(describing: query))")
//                                observer.onCompleted()
//                }
//                return Disposables.create()
//            }
//        }
//
//        let tfDriver = textview.rx.text.orEmpty.asDriver()
//        tfDriver.drive(btn.rx.title(for: .normal))
//        let results = tfDriver
//            .throttle(RxTimeInterval.microseconds(300))
//            .flatMapLatest { query in
//                fetchData(query)
//                .asDriver(onErrorJustReturn: "错误事件")
//            }
//
//        results.map { "\($0.count)"}
//            .drive(testLabel.rx.text)
//        .disposed(by: disposebag)
//
//        results.drive(testLabel1.rx.text)
//        .disposed(by: disposebag)
//
//        let data = Observable.of(1,2,3,4,5).map { i in
//            print(Thread.current)
//            print(i)
//        }
//        data.subscribeOn(MainScheduler.instance)
//            .observeOn(MainScheduler.instance).subscribe(onNext: { e in
//                print(Thread.current)
//                print(e)
//            }).disposed(by: disposebag)
        
//        textField.rx.text.orEmpty.asObservable().subscribe(onNext: {
//            self.testLabel.text = $0
//            }).disposed(by: disposebag)
            
//        textField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
//            .asDriver()
//            .map{ "开始或结束" }
//            .drive(testLabel.rx.text)
//            .disposed(by: disposebag)
//        textview.rx.didBeginEditing.map({
//            "开始编辑"
//        }).bind(to: testLabel.rx.text)
//            .disposed(by: disposebag)
//        textview.rx.didEndEditing.map({
//            "结束编辑"
//        }).bind(to: testLabel.rx.text)
//            .disposed(by: disposebag)
//        textview.rx.didChange.map({
//            "内容变化\($0)"
//        }).bind(to: testLabel.rx.text)
//            .disposed(by: disposebag)
//        textview.rx.didChangeSelection.map({
//            "部分选中内容变化\($0)"
//        }).bind(to: testLabel.rx.text)
//            .disposed(by: disposebag)
        
//        Observable.combineLatest(textField.rx.text.orEmpty, textField1.rx.text.orEmpty) { (s1, s2) -> String in
//            return "r输入的好吗是\(s1), \(s2)"
//            }
//            .bind(to: testLabel.rx.text)
//            .disposed(by: disposebag)
//        let tfInput = textField.rx.text.orEmpty.asDriver()
//        tfInput.drive(textField1.rx.text)
//            .disposed(by: disposebag)
//        tfInput.map { (i) -> String in
//            return "当前字数:\(i.count)"
//            }.drive(testLabel.rx.text).disposed(by: disposebag)
//
//        tfInput.map {
//            $0.count > 3
//            }.drive(btn.rx.isEnabled).disposed(by: disposebag)
        
//        textField.rx.text.orEmpty.asObservable().bind(to: textField1.rx.text)
        
//        textField.rx.text.changed.subscribe(onNext: {
//        self.testLabel1.text = $0
//        }).disposed(by: disposebag)
        
//        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//
//        timer.map {
//            String(format: "%d", arguments: [$0])
//        }.bind(to: btn.rx.title(for: .normal)).disposed(by: disposebag)
        
        
//        let s = Observable.generate(initialState: 0, condition: { i -> Bool in
//            return i < 10
//        }, iterate: { i in
//            i + 2
//        })
        
//        s.bind { i in
//            self.testLabel1.text = String(i)
//        }.disposed(by: disposebag)
//
//        let observer: AnyObserver<Int> = AnyObserver.init { (e) in
//            switch e {
//            case .next(let i):
//                self.testLabel1.text = String(i)
//            case .error(let e):
//                print(e)
//            case .completed:
//                print("completed")
//            }
//        }
        
//        let observer: Binder<String> = Binder(testLabel) { (view, text) in
//            //收到发出的索引数后显示到label上
//            view.text = text
//        }
//        let observer: Binder<String> = Binder(testLabel) { (view, text) in
//            view.text = text
//        }
//
//        s.map({ "数字\($0)"
//        }).bind(to: observer)
//        s.subscribe(onNext: { i in
//            print(i)
//            }).disposed(by: disposebag)
//        let map = Observable.of(1).map { i in
//            i + 2
//        }
//        print(type(of: map))
//        let mapflat = Observable.of(1).flatMap { i in
//            return Observable.of(i + 2)
//        }
//        print(type(of: mapflat))
//
//        self.rx.viewWillAppear.subscribe(onNext: { e in
//            print(e)
//        }, onError: { (e) in
//            print(e)
//        }, onCompleted: {
//            print("complete")
//        }) {
//            print("dispose")
//        }
        
//        let observable = Observable<String>.create { observer -> Disposable in
//            observer.onNext("A")
//            observer.onNext("B")
//            observer.onNext("C")
//            observer.onCompleted()
//            return Disposables.create {
//                print("销毁释放")
//            }
//        }
//        
//        
//        observable.subscribe(onNext: { (x) in
//            print(x)
//        }, onError: nil, onCompleted: {
//            print("completed")
//        }, onDisposed: {
//            print("subscribe销毁释放")
//        }).disposed(by: disposebag)
        
//          observable.subscribe { (event) in
//            switch event {
//            case .next(let value) : print(value)
//            case.error(let error) : print(error)
//            case.completed: print("completed")
//            }
            
//        }
        
        
//        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//
//       observable
//           .map { "当前索引数：\($0 )"}
//           .bind { [weak self](text) in
//               //收到发出的索引数后显示到label上
//            self?.btn .setTitle(text, for: .normal)
//            self?.btn.setTitleColor(UIColor.green, for: .normal)
//           }
//           .disposed(by: disposebag)
////        btn?.addTarget(self, action: #selector(selectAction(btn:)), for: .touchUpInside)
//        // Do any additional setup after loading the view.
//
//        let observer: Binder<Bool> = Binder(btn) { (btn, isenable) in
//            print(isenable)
//            btn.isEnabled = isenable
//        }

//        let o = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        o.filter { x in
//            return x%2 == 0
//        }.map({ "\($0)"
//        }).bind(to: btn.rx.title(for: .normal)).disposed(by: disposebag)
    }
    
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.setNavigationBarHidden(true, animated: true)
   }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

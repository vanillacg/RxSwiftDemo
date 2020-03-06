//
//  CGAccountViewController.swift
//  CGMK
//
//  Created by chenguang on 2019/5/10.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class CGAccountViewController: UIViewController {
    lazy var btn1 : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 50, y: 400, width: 200, height: 40.0)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.textColor = UIColor.black
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.backgroundColor = UIColor.blue
        btn.isEnabled = false
        btn .setTitle("注册", for: .normal)
        _ = btn.rx.tap.subscribe(onNext: { (x) in
            self.navigationController?.popViewController(animated: true)
        })
        btn .setTitleColor(UIColor.red, for: .disabled)
        return btn
    }()
    
    private lazy var nameTF: UITextField = {
        let tf = UITextField.init(frame: CGRect(x: 50.0, y: 50.0, width: 200, height: 40.0))
        tf.placeholder = "用户名"
        tf.backgroundColor = UIColor.white
        tf.textColor = .black
        return tf
    }()
    
    lazy var nameLabel : UILabel = {
     let testLabel = UILabel()
        testLabel.frame = CGRect(x: 50.0, y: 100.0, width: 280.0, height: 40.0)
        testLabel.backgroundColor = UIColor.white
        testLabel.textColor = .green
        return testLabel
    }()
    
    private lazy var passwordTF: UITextField = {
        let tf = UITextField.init(frame: CGRect(x: 50.0, y: 150.0, width: 100, height: 40.0))
        tf.placeholder = "密码"
        tf.backgroundColor = UIColor.white
        tf.textColor = .black
        return tf
    }()
    
    lazy var passwordLabel : UILabel = {
    let testLabel = UILabel()
        testLabel.frame = CGRect(x: 50.0, y: 200.0, width: 280.0, height: 40.0)
        testLabel.backgroundColor = UIColor.white
        testLabel.textColor = .black
        return testLabel
    }()
    
    private lazy var passwordTF2: UITextField = {
        let tf = UITextField.init(frame: CGRect(x: 50.0, y: 250.0, width: 100, height: 40.0))
        tf.placeholder = "再次输入密码"
        tf.backgroundColor = UIColor.white
        tf.textColor = .black
        return tf
    }()
    
    lazy var passwordLabel2 : UILabel = {
     let testLabel = UILabel()
        testLabel.frame = CGRect(x: 50.0, y: 450.0, width: 300.0, height: 40.0)
        testLabel.backgroundColor = UIColor.white
        testLabel.textColor = .green
        return testLabel
    }()
    
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号"
        view.backgroundColor = UIColor.white
        view.addSubview(btn1)
        view.addSubview(nameTF)
        view.addSubview(nameLabel)
        view.addSubview(passwordTF)
        view.addSubview(passwordTF2)
        view.addSubview(passwordLabel)
        view.addSubview(passwordLabel2)
        
        let usernameDriver : Driver<String> = nameTF.rx.text.orEmpty.asDriver()
        let passwordDriver : Driver<String> = passwordTF.rx.text.orEmpty.asDriver()
        let passwordRepeatedDriver : Driver<String> = passwordTF2.rx.text.orEmpty.asDriver()
        let loginTaps : Signal<Void> = btn1.rx.tap.asSignal()
        //初始化ViewModel
        let viewModel = AccountVM(
            input: (
                userName: usernameDriver,
                password: passwordDriver,
                repeatedPassword: passwordRepeatedDriver,
                loginTaps: loginTaps
                ),
            service: AccountService()
        )

        //用户名验证结果绑定
        viewModel.validateUserName
            .drive(nameLabel.rx.validationResult)
            .disposed(by: disposeBag)

        //密码验证结果绑定
        viewModel.validatePassword
            .drive(passwordLabel.rx.validationResult)
            .disposed(by: disposeBag)

        //再次输入密码验证结果绑定
        viewModel.validatePasswirdRepeated
            .drive(passwordLabel2.rx.validationResult)
            .disposed(by: disposeBag)

        //注册按钮是否可用
        viewModel.signupEnable
            .drive(onNext: { [weak self] valid  in
                self?.btn1.isEnabled = valid
                self?.btn1.alpha = valid ? 1.0 : 0.3
            })
            .disposed(by: disposeBag)

        //注册结果绑定
        viewModel.signupResult
            .drive(onNext: { [unowned self] result in
                self.showMessage("注册" + (result ? "成功" : "失败") + "!")
            })
            .disposed(by: disposeBag)

    }
//
    //详细提示框
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//扩展UILabel
extension Reactive where Base: UILabel {
    //让验证结果（ValidationResult类型）可以绑定到label上
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

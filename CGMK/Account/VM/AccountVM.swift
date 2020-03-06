//
//  AccountVM.swift
//  CGMK
//
//  Created by chenguang on 2020/3/5.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AccountVM {
    let validateUserName: Driver<ValidationResult>
    
    let validatePassword: Driver<ValidationResult>
    
    let validatePasswirdRepeated : Driver<ValidationResult>
    
    let signupEnable: Driver<Bool>
    
    let signupResult: Driver<Bool>
        
    init(input:
        (
        userName: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Signal<Void>
        ),
         service: AccountService) {
        
            validateUserName = input.userName.flatMapLatest{ userName in
                return service.validateUserName(userName).asDriver(onErrorJustReturn: .failed(message: "服务器发生错误"))
            }
            
            validatePassword = input.password.map({ password in
                return service.validatePassword(password)
            })
            
            validatePasswirdRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: service.validateRepeatedPassword)
            
            signupEnable = Driver.combineLatest(validateUserName, validatePassword, validatePasswirdRepeated) { userName, password, repeatedPassword in
                userName.isValid && password.isValid && repeatedPassword.isValid
            }.distinctUntilChanged()
            
            let userNameAndPassword = Driver.combineLatest(input.userName, input.password) { (userName: $0, password: $1)}
            
            signupResult = input.loginTaps.withLatestFrom(userNameAndPassword).flatMapLatest({ pair in
                return service.signup(pair.userName, password: pair.password).asDriver(onErrorJustReturn: false)
            })
        }
}

//
//  AccountService.swift
//  CGMK
//
//  Created by chenguang on 2020/3/5.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxSwift

class AccountService {
    func userNameValid(_ userName: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(userName.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { pair in
                return pair.response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func signup(_ userName: String, password: String) -> Observable<Bool> {
        let signResult = arc4random() % 3 == 0 ? false : true
        return Observable.just(signResult)
            .delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
    }
    
    let minPasswordCount = 5
    
    func validateUserName(_ userName: String) -> Observable<ValidationResult> {
        if userName.isEmpty {
            return .just(.empty)
        }
        if userName.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        
        return userNameValid(userName).map { avaiable in
            if avaiable {
                return .ok(message: "用户名可用")
            } else {
                return .failed(message: "用户名已存在")
            }
        }
        .startWith(.validating) 
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
         
        if numberOfCharacters == 0 {
            return .empty
        }
         
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要 \(minPasswordCount) 个字符")
        }
         
        return .ok(message: "密码有效")
    }
     
    //验证二次输入的密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String)
        -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
         
        if repeatedPassword == password {
            return .ok(message: "密码有效")
        } else {
            return .failed(message: "两次输入的密码不一致")
        }
    }
}

extension String {
    //字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

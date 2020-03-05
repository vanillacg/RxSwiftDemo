//
//  GitHubNetworkService.swift
//  CGMK
//
//  Created by chenguang on 2020/2/24.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxCocoa
import ObjectMapper
import RxSwift

class GitHubNetworkService {
     
    //搜索资源数据
    func searchRepositories(query:String) -> Driver<GitHubRepositories> {
        return GitHubProivder.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .mapObject(GitHubRepositories.self)
            .asDriver(onErrorDriveWith: Driver.empty())
//            .mapObject(GitHubRepositories.self)
//            .asObservable()
//            .catchError({ error in
//                print("发生错误：",error.localizedDescription)
//                return Observable<GitHubRepositories>.empty()
//            })
    }
}

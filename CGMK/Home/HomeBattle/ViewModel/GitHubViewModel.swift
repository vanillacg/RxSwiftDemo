//
//  GitHubViewModel.swift
//  CGMK
//
//  Created by chenguang on 2020/2/24.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GitHubViewModel {
    let searchAction: Driver<String>
    let searchResult: Driver<GitHubRepositories>
    let repositories: Driver<[GitHubRepository]>
    let cleanResult: Driver<Void>
    let navigationTitle: Driver<String>

    let networkService = GitHubNetworkService()
    
    init(searchAction: Driver<String>) {
        self.searchAction = searchAction
        self.searchResult = searchAction.filter{ s in
            print(s)
            return !s.isEmpty
    }.flatMapLatest(networkService.searchRepositories)
        
        self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
        self.repositories = Driver.merge(searchResult.map{ $0.items }, cleanResult.map{[]}).filter{ x in print(x);  return x.count > 0}
        self.navigationTitle =  Driver.merge(searchResult.map{ "共有\($0.totalCount!)个结果" }, cleanResult.map{"hangge.com"})
    }
}

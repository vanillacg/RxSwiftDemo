//
//  JobViewModel.swift
//  CGMK
//
//  Created by chenguang on 2020/2/19.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class JobViewModel {
    let tableData = BehaviorRelay<[Channel]>(value: [])

    let endHeaderRefreshing: Driver<Bool>
    let endFooterRefreshing: Driver<Bool>

    init(input:(headrRefresh: Driver<Void>, footerRefresh: Driver<Void>), dependency:(disposeBag: DisposeBag, networkService: JobNetworkService)) {
        
        //下拉刷新结果序列
        let headerRefreshData = input.headrRefresh.startWith(()).flatMapFirst{
            return dependency.networkService.loadChannelsDriver() }
        
        //上拉加载更多结果序列
        let footerRefreshData = input.footerRefresh.startWith(()).flatMapLatest{
            return dependency.networkService.loadChannelsDriver()
        }
        //生成停止头部刷新状态序列
        self.endHeaderRefreshing = headerRefreshData.map{_ in true}
        //生成停止尾部刷新状态序列
        self.endFooterRefreshing = footerRefreshData.map{_ in true}
        //下拉刷新时，直接将查询到的结果替换原数据
        headerRefreshData.drive(onNext: { channels in
            self.tableData.accept(channels)
        }).disposed(by: dependency.disposeBag)
        
        footerRefreshData.drive(onNext: { channels in
            self.tableData.accept((self.tableData.value) + channels)
        }).disposed(by: dependency.disposeBag)
    }
}

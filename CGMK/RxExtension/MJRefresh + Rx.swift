//
//  MJRefresh + Rx.swift
//  CGMK
//
//  Created by chenguang on 2020/2/17.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    var endRefreshing: Binder<Bool> {
        return Binder(base) {
            refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

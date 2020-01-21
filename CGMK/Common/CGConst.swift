//
//  CGConst.swift
//  CGMK
//
//  Created by chenguang on 2019/5/16.
//  Copyright © 2019 chenguang. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

let CGScreenWidth = UIScreen.main.bounds.width
let CGScreenHeight = UIScreen.main.bounds.height

//let CG_isIPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
let CGIsIPhoneX = CGScreenWidth == 812.0
let CGNavigatorHeight: CGFloat = CGIsIPhoneX ? 88 : 64.0

let BASE_URL = "https://is.snssdk.com"
let device_id: Int = 6096495334
let iid: Int = 5034850950

enum TTFrom: String {
    case pull = "pull"
    case loadMore = "load_more"
    case auto = "auto"
    case enterAuto = "enter_auto"
    case preLoadMoreDraw = "pre_load_more_draw"
}
let newsTitleHeight: CGFloat = 40


//
//  CGHomeColumnVC.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CGHomeColumnVC: UIViewController {
    
    let disposeBag = DisposeBag()
    lazy var btn : UIButton = {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            btn.backgroundColor = UIColor.white
    //        btn.titleLabel?.textColor = UIColor.black
            btn.setTitle("发送请求", for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.red, for: .highlighted)
            _ = btn.rx.tap.subscribe(onNext: { (x) in
                print(x)
            })
            btn .setTitleColor(UIColor.red, for: .disabled)
            return btn
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        view.addSubview(btn)
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
            
        btn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.json(request: request)
        }.subscribe(onNext: { data in
//            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print("json:\(data)")
            }).disposed(by: disposeBag)
        
        
//        //创建并发起请求
//        URLSession.shared.rx.data(request: request).subscribe(onNext: {
//            data in
//            let str = String(data: data, encoding: String.Encoding.utf8)
//            print("请求成功！返回的数据是：", str ?? "")
//        }).disposed(by: disposeBag)
    }

}

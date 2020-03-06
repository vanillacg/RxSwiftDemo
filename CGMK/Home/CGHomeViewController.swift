//
//  CGHomeViewController.swift
//  CGMK
//
//  Created by chenguang on 2019/5/10.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CGHomeViewController: UIViewController {
   
     @objc dynamic var message = "hangge.com"

    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor = UIColor.white
        let recVC = CGHomeRecommendVC()
        recVC.title = "推荐"
        let freeVC = CGHomeFreeVC()
        freeVC.title = "免费课"
        let battleVC = CGHomeBattleVC()
        battleVC.title = "实战课"
        let jobVC = CGHomeJobVC()
        jobVC.title = "就业班"
        let columnVC = CGHomeColumnVC()
        columnVC.title = "专栏"
        let vcs = [recVC,freeVC,battleVC,jobVC,columnVC]
        let VCContainer = CGVCContainer(frame: view.bounds, parentVC : self)
        VCContainer.contentVCs = vcs
        view.addSubview(VCContainer)
        
        //定时器（1秒执行一次）
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                //每次给字符串尾部添加一个感叹号
                self.message.append("!")
            }).disposed(by: disposeBag)
         
        //监听message变量的变化
        _ = self.rx.observeWeakly(String.self, "message")
            .subscribe(onNext: { (value) in
            print(value ?? "")
        })
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

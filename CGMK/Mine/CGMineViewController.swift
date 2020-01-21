//
//  CGMineViewController.swift
//  CGMK
//
//  Created by chenguang on 2019/5/10.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CGMineViewController: UIViewController {
    lazy var btn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100.0, y: 100.0, width: 100.0, height: 100.0)
        btn.backgroundColor = UIColor.black
        btn.titleLabel?.textColor = UIColor.black
        btn.setTitleColor(UIColor.red, for: .highlighted)
        _ = btn.rx.tap.subscribe(onNext: { (x) in
            let freevc = CGHomeFreeVC()
            self.navigationController?.pushViewController(freevc, animated: true)
        })
        btn .setTitleColor(UIColor.red, for: .disabled)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我听"
        view.backgroundColor = UIColor.white
        view.addSubview(btn)
        
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

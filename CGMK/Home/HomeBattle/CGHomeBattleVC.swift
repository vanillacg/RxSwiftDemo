//
//  CGHomeBattleVC.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CGHomeBattleVC: UIViewController {

     let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0.0, y: 0.0, width: CGScreenWidth, height: CGScreenHeight - CGNavigatorHeight), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        view.addSubview(tableView)
        
        let items = Observable.just(["a", "b", "c"])
        
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
//        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let vc = CGDetailVC.init(item: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中的标题:\(item)")
            }).disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).subscribe(onNext: { indexPath, model in
            print(indexPath, model)
            }).disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemDeselected, tableView.rx.modelDeselected(String.self)).subscribe(onNext: { indexPath, model in
        print(indexPath, model)
        }).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
        print(cell, indexPath)
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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

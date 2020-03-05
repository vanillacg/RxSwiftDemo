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

    var disposeBag: DisposeBag = DisposeBag()
     
    private lazy var tableView: UITableView = {
    let tableView = UITableView.init(frame: CGRect(x: 0.0, y: 40 + 56.0, width: CGScreenWidth, height: CGScreenHeight - CGNavigatorHeight - 40 - 56), style: .plain)
         tableView.register(MKCourseCell.self, forCellReuseIdentifier: UITableViewCell.description())
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 90
         tableView.delegate = nil
         tableView.dataSource = nil
         tableView.showsVerticalScrollIndicator = true
         return tableView
     }()
    
    lazy var testLabel : UILabel = {
     let testLabel = UILabel()
        testLabel.frame = CGRect(x: 0.0, y: 56.0, width: CGScreenWidth, height: 40)
        testLabel.backgroundColor = UIColor.red
        testLabel.textColor = .black
        return testLabel
    }()
     
    lazy var searchBar : UISearchBar = {
           let s = UISearchBar.init(frame: CGRect(x: 0, y: 0.0, width: CGScreenWidth, height: 56.0))
           s.placeholder = "search"
            
           return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(testLabel)
        
        let searchAction = searchBar.rx.text.orEmpty.asDriver()
            .throttle(RxTimeInterval.microseconds(500))
            .distinctUntilChanged()
        
        let viewModel = GitHubViewModel(searchAction: searchAction)
        viewModel.navigationTitle.drive(self.testLabel.rx.text).disposed(by: disposeBag)

        viewModel.repositories.drive(tableView.rx.items) { (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.description())
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlUrl
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GitHubRepository.self).subscribe(onNext: {[weak self] item in
            self?.showAlert(title: item.fullName, message: item.descripation)
            }).disposed(by: disposeBag)
        
//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).subscribe(onNext: { indexPath, model in
//            print(indexPath, model)
//            }).disposed(by: disposeBag)
        
        
    }
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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

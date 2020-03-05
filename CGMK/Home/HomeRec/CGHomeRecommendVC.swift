//
//  CGHomeRecommendVC.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import os.log

class CGHomeRecommendVC: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private var homeRecVM = MKHomeRecVM()
    private var dateSource: RxTableViewSectionedReloadDataSource<SectionModel<String,NewsContentItem>>!
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0.0, y: 60.0, width: CGScreenWidth, height: CGScreenHeight - CGNavigatorHeight - 60), style: .plain)
        tableView.register(MKCourseCell.self, forCellReuseIdentifier: MKCourseCell.description())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    lazy var searchBar : UISearchBar = {
          let s = UISearchBar.init(frame: CGRect(x: 0, y: 0.0, width: CGScreenWidth, height: 60.0))
          s.placeholder = "search"
          return s
    }()

    override func viewDidLoad() {
        kdebug_signpost_start(30, 0, 0, 0, 3);
        kdebug_signpost_start(10, 0, 0, 0, 1);

        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        view.addSubview(tableView)
//        rxswift()
        bindVM()
        homeRecVM.loadData()
        kdebug_signpost_end(10, 0, 0, 0, 1);
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        kdebug_signpost_start(20, 0, 0, 0, 2);
        super.viewDidAppear(animated)
        kdebug_signpost_end(20, 0, 0, 0, 2);
        kdebug_signpost_end(30, 0, 0, 0, 3);
    }
    
    
    private func bindVM() -> Void {
        dateSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NewsContentItem>> ( configureCell: { (ds, tableView, indexPath, item) -> UITableViewCell in
            let cell: MKCourseCell = tableView.dequeueReusableCell(withIdentifier: MKCourseCell.description()) as! MKCourseCell
            cell.installCellData(cellData: item)
            return cell
        })
        homeRecVM.newsSection.asObservable().bind(to: tableView.rx.items(dataSource: dateSource!)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let item = self?.dateSource[indexPath]
            if let item = item {
                let dvc = CGDetailVC(item:item)
                self?.navigationController?.pushViewController(dvc, animated: true)
            }
        }).disposed(by: disposeBag)
        tableView.rx.modelSelected(NewsContentItem.self).subscribe { item in
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelDeselected(NewsContentItem.self).subscribe { item in
            print(item)
        }.disposed(by: disposeBag)
    }
}


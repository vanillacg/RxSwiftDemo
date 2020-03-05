//
//  CGHomeJobVC.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import Moya
import ObjectMapper
import Moya_ObjectMapper
import MJRefresh

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = String
    var identity: String {
        return header
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
}

enum TableEditingCommand {
    case setItems(items: [String])
    case addItem(items: String)
    case moveItem(from: IndexPath, to: IndexPath)
    case deleteItem(IndexPath)
}

struct TableViewModel {
    fileprivate var items: [String]
    init(items: [String] = []) {
        self.items = items
    }
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据.")
            return TableViewModel(items: items)
        case .addItem(let item):
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexPath):
            print("删除数据项。")
            var items = self.items
            items.remove(at: indexPath.row)
            return TableViewModel(items: items)
        }
    }
}

class CGHomeJobVC: UIViewController {
    
       let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, [String : Any]>>?
    
       private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0.0, y: 60.0, width: CGScreenWidth, height: CGScreenHeight - CGNavigatorHeight - CGToolBarHeight - 60.0), style: .plain)
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SwiftCell")
           tableView.showsVerticalScrollIndicator = true
//        tableView.delegate = self
//        tableView.dataSource = self
           return tableView
       }()
    
        lazy var btn : UIButton = {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            btn.backgroundColor = UIColor.white
    //        btn.titleLabel?.textColor = UIColor.black
            btn.setTitle("刷新", for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.red, for: .highlighted)
            _ = btn.rx.tap.subscribe(onNext: { (x) in
                print(x)
            })
            btn .setTitleColor(UIColor.red, for: .disabled)
            return btn
        }()
    
    lazy var btn2 : UIButton = {
               let btn = UIButton(type: .custom)
               btn.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
               btn.backgroundColor = UIColor.white
       //        btn.titleLabel?.textColor = UIColor.black
               btn.setTitle("刷新", for: .normal)
               btn.setTitleColor(UIColor.black, for: .normal)
               btn.setTitleColor(UIColor.red, for: .highlighted)
               _ = btn.rx.tap.subscribe(onNext: { (x) in
                   print(x)
               })
               btn .setTitleColor(UIColor.red, for: .disabled)
               return btn
           }()
    
    lazy var searchBar : UISearchBar = {
        let s = UISearchBar.init(frame: CGRect(x: 0, y: 0.0, width: CGScreenWidth, height: 60.0))
        s.placeholder = "search"
        return s
        }()
    let initialVM = TableViewModel()
    
    var channels:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        view.addSubview(tableView)
//        view.addSubview(btn)
//        view.addSubview(btn2)
        view.addSubview(searchBar)
        

        
        
        let sections = Observable.just([
            MySection(header: "1", items: ["a", "b", "c"]),
            MySection(header: "2", items: ["1", "2", ""])
        ])
        
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
//       let dataObservable = btn.rx.tap.asObservable()
//            .flatMap {
//                URLSession.shared.rx.json(request: request)
//       }.map{ (json) -> SectionModel<String,[String : Any]> in
//            if let data = json as? [String: Any] {
//                let channels = data["channel"] as! [[String: Any]]
//                    return SectionModel(model: "channel", items: channels)
//            } else {
//                return SectionModel(model: "", items: [])
//            }
//       }
        
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, [String : Any]>> (
//            configureCell: { ds, tv, ip, item in
//                let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
//                cell.textLabel?.text = "\(ip.row):\(String(describing: item["name"]))"
//                return cell
//        },
//            titleForHeaderInSection: { ds, index  in
//                return ds.sectionModels[index].description
//        }
//        )
        
//        self.dataSource = dataSource
        //获取列表数据
        //1.URLSession.shared.rx
//        let data = URLSession.shared.rx.json(request: request)
//            .mapObject(type: Douban.self)
//            .map { (d) -> [Channel] in
//                d.channels ?? []
//        }
//        data.bind(to: tableView.rx.items) { (tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
//            cell.textLabel?.text = "\(row)：\(element.name!)"
//            return cell
//        }.disposed(by: disposeBag)
        
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
//      2 . DouBanProvider
//        DouBanProvider.request(.channels) { result in
//            switch result {
//            case .success(let response):
//                let data = try? response.mapJSON()
//                let json = JSON(data!)
//                self.channels = json["channels"].arrayValue
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                break
//            case .failure(_): break
//            }
//            if case let .success(response) = result {
//                let data = try? response.mapJSON()
//                let json = JSON(data!)
//                self.channels = json["channels"].arrayValue
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
        //3. DouBanProvider.rx
//        _ = DouBanProvider.rx.request(.channels).subscribe { event in
//            switch event {
//            case let .success(response):
//                let data = try? response.mapJSON()
//                let json = JSON(data!)
//                self.channels = json["channels"].arrayValue
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                break
//            case let .error(error):
//                print("数据请求失败:",error)
//            }
//
//        }
        
        //4.DouBanProvider.rx
//    let data = DouBanProvider.rx.request(.channels)
//            .mapJSON()
//            .map { data -> [[String: Any]] in
//                if let json = data as? [String: Any], let channels = json["channels"] as? [[String: Any]] {
//                    return channels
//                } else {
//                    return []
//                }
//            }.asObservable()
    
    //将数据绑定到表格
//        //将数据绑定到表格
//        data.bind(to: tableView.rx.items) { (tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftCell")!
//            cell.textLabel?.text = "\(element["name"]!)"
//            cell.accessoryType = .disclosureIndicator
//            return cell
//            }.disposed(by: disposeBag)
//
//        tableView.rx.modelSelected([String: Any].self).map {
//            $0["channel_id"] as! String
//        }.flatMap { DouBanProvider.rx.request(.playlist($0))}.mapJSON().subscribe(onNext: { [weak self] data in
//            if let json  = data as? [String: Any],
//                let musics = json["song"] as? [[String: Any]] {
//                let artist = musics[0]["artist"]!
//                let title = musics[0]["title"]!
//                let message = "歌手:\(artist)\n歌曲:\(title)"
//                self?.showAlert(title: "歌曲信息", message: message)
//            }
//
//        })
//    }
    //5. moya-objectmap
//        let data = DouBanProvider.rx.request(.channels)
//            .mapObject(Douban.self)
//            .map{ $0.channels ?? []}
//            .asObservable()
        
//        let networkService = JobNetworkService()
//        let data = networkService.loadChannelsDriver()
        
//        data.drive(tableView.rx.items) { (tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftCell")!
//            cell.textLabel?.text = "\(element.name!)"
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }.disposed(by: disposeBag)
        
        self.tableView.mj_header = MJRefreshNormalHeader()
        self.tableView.mj_footer = MJRefreshBackNormalFooter()
        
        let viewmodel = JobViewModel(
            input: (
                headrRefresh: self.tableView.mj_header!.rx.refreshing.asDriver(),
                footerRefresh: self.tableView.mj_footer!.rx.refreshing.asDriver()),
            dependency: (
                disposeBag: disposeBag,
                networkService: JobNetworkService()
            )
        )
        
        viewmodel.tableData.asDriver().drive(tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftCell")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        //下拉刷新
        viewmodel.endHeaderRefreshing
            .drive(self.tableView.mj_header!.rx.endRefreshing)
            .disposed(by: disposeBag)
        
        viewmodel.endFooterRefreshing
            .drive(self.tableView.mj_footer!.rx.endRefreshing)
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(Channel.self)
            .map({ channel in
                print(channel)
                return channel.channelId ?? "0"
            })
                   .flatMap( JobNetworkService().loadFirstSong )
                   .subscribe(onNext: { [weak self] song in
                           let artist = song.artist!
                           let title = song.title!
                           let message = "歌手:\(artist)\n歌曲:\(title)"
                           self?.showAlert(title: "歌曲信息", message: message)
                   }).disposed(by: disposeBag)
        
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.channels.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identify: String = "SwiftCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
//        cell.accessoryType = .disclosureIndicator
//
//        cell.textLabel?.text = self.channels[indexPath.row]["name"].stringValue
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let channelName = channels[indexPath.row]["name"].stringValue
//        let channelId = channels[indexPath.row]["channel_id"].stringValue
//        DouBanProvider.request(.playlist(channelId)) { result in
//            if case let .success(response) = result {
//                let data = try?response.mapJSON()
//                let json = JSON(data!)
//                let music  = json["song"].arrayValue[0]
//                let artist = music["artist"].stringValue
//                let title = music["title"].stringValue
//                let message = "歌手:\(artist)\n歌曲:\(title)"
//                //将歌曲信息弹出显示
//                self.showAlert(title: channelName, message: message)
//            }
//
//            if case let .failure(error) = result {
//                //将歌曲信息弹出显示
//                self.showAlert(title: "出错", message: error.errorDescription ?? "xxx")
//            }
//        }
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
//        tableView.setEditing(true, animated: true)
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

//extension CGHomeJobVC : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let _ = dataSource?[indexPath], let _ = dataSource?[indexPath.section] else {
//            return 0.0
//        }
//        return 60
//    }
//}

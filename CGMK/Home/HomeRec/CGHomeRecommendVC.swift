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
        let tableView = UITableView.init(frame: CGRect(x: 0.0, y: 0.0, width: CGScreenWidth, height: CGScreenHeight - CGNavigatorHeight), style: .plain)
        tableView.register(MKCourseCell.self, forCellReuseIdentifier: MKCourseCell.description())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    
//    enum MyError: Error {
//        case A
//        case B
//    }
//    //获取豆瓣某频道下的歌曲信息
//    func getPlaylist(_ channel: String) -> Single<[String: Any]> {
//        return Single<[String: Any]>.create { single in
//            let url = "https://www.hangge.com/blog/cache/detail_1939.html"
//            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
//                if let error = error {
//                    single(.error(error))
//                    return
//                }
//
//                guard let data = data,
//                    let json = try? JSONSerialization.jsonObject(with: data,
//                                                                 options: .mutableLeaves),
//                    let result = json as? [String: Any] else {
//                        single(.error(DataError.cantParseJSON))
//                        return
//                }
//
//                single(.success(result))
//            }
//
//            task.resume()
//
//            return Disposables.create { task.cancel() }
//        }
//    }
//
//    func cacheLocal() -> Completable {
//        return Completable.create { (completable) -> Disposable in
//            let success = (arc4random() % 2 == 0)
//            guard success else {
//                completable(.error(DataError.cantParseJSON))
//                return Disposables.create()
//            }
//            completable(.completed)
//            return Disposables.create()
//        }
//    }
//
//    //与数据相关的错误类型
//    enum DataError: Error {
//        case cantParseJSON
//    }
    func rxswift() {
        
//        let disposeBag = DisposeBag()
//        
//        _ = cacheLocal().subscribe(onCompleted: {
//            print("成功")
//        }, onError: { (e) in
//            print(e)
//            }).disposed(by: disposeBag)
        
//        _ = getPlaylist("0").subscribe { event in
//            switch event {
//            case .success(let json):
//                print("JSON结果: ", json)
//            case .error(let error):
//                print("发生错误: ", error)
//            }
//        }
//        .disposed(by: disposeBag)
        
//        func delay(_ delay: Double, closure: @escaping () -> Void) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                closure();
//            }
//        }
//
//        let s = PublishSubject<String>()
//        s.catchErrorJustReturn("错误")
//            .subscribe(onNext: { (e) in
//                print(e)
//            }).disposed(by: disposeBag)
//
//        s.onNext("a")
//        s.onNext("b")
//        s.onNext("c")
//        s.onError(MyError.A)
//        s.onNext("d")
        
        
//        //创建一个Subject（后面的multicast()方法中传入）
//        let subject = PublishSubject<Int>()
//
//        //这个Subject的订阅
//        _ = subject
//            .subscribe(onNext: { print("Subject: \($0)") })
         
        //每隔1秒钟发送1个事件
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        _ = interval.subscribe(onNext: { print("订阅1:\($0)") })
////        delay(2) {
////            _ = interval.connect()
////        }
//        delay(5) {
//            _ = interval.subscribe(onNext: { print("订阅2:\($0)") })
//        }
        
        
        
//        let times = [
//            [ "value": 1, "time": 0.1 ],
//            [ "value": 2, "time": 1.1 ],
//            [ "value": 3, "time": 1.2 ],
//            [ "value": 4, "time": 1.6 ],
//            [ "value": 5, "time": 1.7 ],
//            [ "value": 6, "time": 2.1 ]
//        ]
//
//        Observable.from(times)
//            .flatMap { item in
//                return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
//        }.timeout(2, scheduler: MainScheduler.instance)
//        .subscribe(onNext: { element in
//            print(element)
//        }, onError: { error in
//            print(error)
//        })
//        .disposed(by: disposeBag)

//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//            .publish()
//            .share(replay: 5)
//
//
//        _ = interval.subscribe(onNext: { print("订阅1:\($0)") })
//        delay(5) {
//            _ = interval
//                .subscribe(onNext: { print("订阅2: \($0)") })
//        }
//        Observable.of(1,2,3,4,5)
//            .reduce(0, accumulator: { (x, y) -> Int in
//                x + y
//            })
//            .subscribe(onNext: { (e) in
//                print(e)
//            }).disposed(by: disposeBag)
//
//
//        let s1 = BehaviorSubject<Int>(value: 1)
//        let s2 = BehaviorSubject<Int>(value: 2)
//
//        s1.asObservable().concat(s2).subscribe(onNext: { (x) in
//            print(x)
//        })
//
//        s2.onNext(4)
//        s1.onNext(3)
//        s1.onNext(5)
//        s1.onNext(7)
//        s2.onNext(6)
//        s1.onCompleted()
//
//        s2.onNext(8)
        
        
                
//        let s1 = PublishSubject<Int>()
//        let s2 = PublishSubject<String>()
//        Observable.zip(s1, s2, resultSelector: { x, y in
//            let s =  String(format: "result%d, %@", x, y)
//            print("x:\(x), y:\(y)")
//            return s
//        }).subscribe(onNext: { (e) in
//            print(e)
//            }).disposed(by: disposeBag)

//        Observable.combineLatest(s1, s2, resultSelector: { x, y in
//            let s =  String(format: "result%d, %@", x, y)
//            print("x:\(x), y:\(y)")
//            return s
//        }).subscribe(onNext: { e in
//            print(e)
//        }).disposed(by: disposeBag)
//        s1.onNext(1)
//        s1.onNext(2)
//        s2.onNext("A")
//        s1.onNext(11)
//        s1.onNext(21)
//        s2.onNext("B")
//        s1.onNext(31)
//        s2.onNext("C")
        
//        let times = [
//            [ "value": 1, "time": 0.1 ],
//            [ "value": 2, "time": 1.1 ],
//            [ "value": 3, "time": 1.2 ],
//            [ "value": 4, "time": 1.2 ],
//            [ "value": 5, "time": 1.4 ],
//            [ "value": 6, "time": 2.1 ]
//        ]
         
        //生成对应的 Observable 序列并订阅
//        Observable.from(times)
//            .flatMap { item in
//                return Observable.of(Int(item["value"]!))
//                    .delaySubscription(Double(item["time"]!),
//                                       scheduler: MainScheduler.instance)
//            }
//            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
//
//        let times = [
//            ["value": 1, "time": 0.1],
//            ["value": 2, "time": 1.1],
//            ["value": 3, "time": 1.2],
//            ["value": 4, "time": 1.2],
//            ["value": 5, "time": 1.4],
//            ["value": 6, "time": 2.1]
//                    ]
        
    }
    override func viewDidLoad() {
        kdebug_signpost_start(30, 0, 0, 0, 3);
        kdebug_signpost_start(10, 0, 0, 0, 1);

        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
//        view.addSubview(tableView)
        rxswift()
//        bindVM()
//        homeRecVM.loadData()
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


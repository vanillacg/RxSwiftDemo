# RxCocoa UITableView

## 一、UITableView 的基本用法

```swift
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
        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
```

获取选中项的索引

```swift
tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let vc = CGDetailVC.init(item: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        })
```

```swift
/**
    Reactive wrapper for `delegate` message `tableView:didSelectRowAtIndexPath:`.
    */
    public var itemSelected: ControlEvent<IndexPath> {
        let source = self.delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
            .map { a in
                return try castOrThrow(IndexPath.self, a[1])
            }

        return ControlEvent(events: source)
    }
```

获取选中的内容

```
tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中的标题:\(item)")
            }).disposed(by: disposeBag)
```

~~~swift
/**
    Reactive wrapper for `delegate` message `tableView:didSelectRowAtIndexPath:`.
    
    It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    or any other data source conforming to `SectionedViewDataSourceType` protocol.
    
     ```
        tableView.rx.modelSelected(MyModel.self)
            .map { ...
     ```
    */
    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = self.itemSelected.flatMap { [weak view = self.base as UITableView] indexPath -> Observable<T> in
            guard let view = view else {
                return Observable.empty()
            }

            return Observable.just(try view.rx.model(at: indexPath))
        }
        
        return ControlEvent(events: source)
    }
~~~

同时获取选中项的索引及内容

```swift
Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).subscribe(onNext: { indexPath, model in
            print(indexPath, model)
            }).disposed(by: disposeBag)
```

同时获取被取消选中项的索引

```swift
Observable.zip(tableView.rx.itemDeselected, tableView.rx.modelDeselected(String.self)).subscribe(onNext: { indexPath, model in
        print(indexPath, model)
        }).disposed(by: disposeBag)
```

Cell 将要显示出来的事件响应

```swift
tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
        print(cell, indexPath)
        }).disposed(by: disposeBag)
```

## 二、RxDataSources

### 1，RxDataSources 介绍

（1）如果我们的 **tableview** 需要显示多个 **section**、或者更加复杂的编辑功能时，可以借助 **RxDataSource** 这个第三方库帮我们完成。

（2）**RxDataSource** 的本质就是使用 **RxSwift** 对 **UITableView** 和 **UICollectionView** 的数据源做了一层包装。使用它可以大大减少我们的工作量



**注意**：**RxDataSources** 是以 **section** 来做为数据结构的。所以不管我们的 **tableView** 是单分区还是多分区，在使用 **RxDataSources** 的过程中，都需要返回一个 **section** 的数组。

```swift
 let items = Observable.just([
            SectionModel(model: "", items: [
            "a", "b", "c"
            ])
        ])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>> (configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(ip.row): \(model)"
            return cell
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
```

**使用自定义的Section** 

```swift
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
```

```swift
 let items = Observable.just([MySection.init(header: "", items: [
            "a", "b", "c"
        ])])
        
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection> (configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(ip.row): \(model)"
            return cell
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
```

带有section  header数据及UI

```swift
let items = Observable.just([MySection.init(header: "header", items: [
            "a", "b", "c"
        ])])
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection> (configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(ip.row): \(model)"
            return cell
        }, titleForHeaderInSection: { ds, index in
            return ds.sectionModels[index].header
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
```

其中 configureCell:, titleForHeaderInSection: 是做完RxTableViewSectionedReloadDataSource 初始化参数的block,RxTableViewSectionedReloadDataSource 继承自TableViewSectionedDataSource

```swift
open class RxTableViewSectionedReloadDataSource<Section: SectionModelType>
    : TableViewSectionedDataSource<Section>
    , RxTableViewDataSourceType {
    public typealias Element = [Section]

    open func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            #if DEBUG
                dataSource._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            tableView.reloadData()
        }.on(observedEvent)
    }
}
```

```swift
open class TableViewSectionedDataSource<Section: SectionModelType>
    : NSObject
    , UITableViewDataSource
    , SectionedViewDataSourceType {
    
    public typealias Item = Section.Item

    public typealias ConfigureCell = (TableViewSectionedDataSource<Section>, UITableView, IndexPath, Item) -> UITableViewCell
    public typealias TitleForHeaderInSection = (TableViewSectionedDataSource<Section>, Int) -> String?
    public typealias TitleForFooterInSection = (TableViewSectionedDataSource<Section>, Int) -> String?
    public typealias CanEditRowAtIndexPath = (TableViewSectionedDataSource<Section>, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (TableViewSectionedDataSource<Section>, IndexPath) -> Bool

    #if os(iOS)
        public typealias SectionIndexTitles = (TableViewSectionedDataSource<Section>) -> [String]?
        public typealias SectionForSectionIndexTitle = (TableViewSectionedDataSource<Section>, _ title: String, _ index: Int) -> Int
    #endif

    #if os(iOS)
        public init(
                configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
            ) {
            self.configureCell = configureCell
            self.titleForHeaderInSection = titleForHeaderInSection
            self.titleForFooterInSection = titleForFooterInSection
            self.canEditRowAtIndexPath = canEditRowAtIndexPath
            self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
            self.sectionIndexTitles = sectionIndexTitles
            self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
        }
}
```

## 三、数据刷新

```swift
func getRandomData() -> Observable<[MySection]> {
            print("正在请求数据...")
            let items = (0 ..< 5).map { _ in
                String(arc4random())
            }
            
            let o = Observable.just([MySection(header: "S", items: items)])
            return o.delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        }
        
        let randomObservable = btn.rx.tap.asObservable()
            .startWith(())//加这个为了让一开始就能自动请求一次数据
            .flatMapLatest {
                getRandomData().takeUntil(self.btn.rx.tap)
        }.share(replay: 1, scope: .whileConnected)
        
//        let items = Observable.just([MySection.init(header: "header", items: [
//            "a", "b", "c"
//        ])])
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection> (configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(ip.row): \(model)"
            return cell
        }, titleForHeaderInSection: { ds, index in
            return ds.sectionModels[index].header
        })
        
        randomObservable.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
```

## 四、数据搜索过滤

### 1，效果图

（1）同前文一样，程序启动后 **tableView** 会默认会加载一些随机数据。而点击右上角的刷新按钮，**tableView** 会重新加载并显示一批新数据。

（2）不同的是，我们在 **tableView** 的表头上增加了一个搜索框。**tableView** 会根据搜索框里输入的内容实时地筛选并显示出符合条件的数据（包含有输入文字的数据条目）

```swift
       func filterData( data: [MySection]) -> Observable<[MySection]> {
            return self.searchBar.rx.text.orEmpty.flatMapLatest { query -> Observable<[MySection]> in
                print("正在筛选数据条件为:\(query)")
                if (query.isEmpty) {
                    return Observable.just(data)
                } else {
                    var newData: [MySection] = []
                    for section in data {
                        let items = section.items.filter { (s) -> Bool in
                            s.contains(query)
                        }
                        newData.append(MySection(header: section.header, items: items))
                    }
                    return Observable.just(newData)
                }
            }
        }
        
        func getRandomData() -> Observable<[MySection]> {
            print("正在请求数据...")
            let items = (0 ..< 5).map { _ in
                String(arc4random())
            }
            
            let o = Observable.just([MySection(header: "S", items: items)])
            return o.delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        }
        
        let randomObservable = btn.rx.tap.asObservable()
            .startWith(())//加这个为了让一开始就能自动请求一次数据
            .flatMapLatest {
                getRandomData()
        }.flatMap({
            filterData(data: $0)
        })
        .share(replay: 1, scope: .whileConnected)
        
//        let items = Observable.just([MySection.init(header: "header", items: [
//            "a", "b", "c"
//        ])])
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection> (configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
            cell.textLabel?.text = "\(ip.row): \(model)"
            return cell
        }, titleForHeaderInSection: { ds, index in
            return ds.sectionModels[index].header
        })
        
        randomObservable.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
```


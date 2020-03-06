004 第二章 第一节： Rx 基本概念  http://t.swift.gg/d/15-004-rx
一.先来理一理可观察序列和观察者是什么
核心概念就是一个观察者(Observer)订阅一个可观察序列(Observable)。观察者对 Observable 发射的数据或数据序列作出响应
这其实就是现实世界的情况，举个例子。你就是观察者，你正在统计某地方的交通情况。每通过一辆车，你就记一下车牌号和车的型号等等。这个时候这一辆辆车就是序列，你对经过的车进行记录就是对序列的响应。
我们的应用也是这样。再看 Button 的点击这个情景。我们把用户一次又一次的点击 Button 看做是序列，通过调用 subscribe 来订阅这个点击事件，每次点击都会发射一个数据，作为订阅者的 subscribe 收到这个这个数据进行某些响应。
这就是 Rx 的基本概念，有观察者观察一个序列，每当序列发射值的时候，观察者根据序列做一些事情。
二.可观察序列 (Observables aka Sequences)
事实上这个序列存在三种情况：发射数据(Next)、遇到问题(Error)、发射完成(Completed)
enum Event<Element>  {
    case Next(Element)      // 序列的下一个元素
    case Error(ErrorType)   // 序列因为某些错误终止
    case Completed          // 正常的序列技术
}
三.观察者 (Observer)
观察者需要一个订阅序列的功能：

class Observable<Element> {
    func subscribe(observer: Observer<Element>) -> Disposable
}

protocol ObserverType {
    func on(event: Event<Element>)
}

通过序列的这个 subscribe 来订阅序列。这里就应该提到序列的“冷”“热”问题。

冷：只有当有观察者订阅这个序列时，序列才发射值；
热：序列创建时就开始发射值。
整体上就是这样的一个关系，序列发射值，观察者订阅序列，收到值，进行处理。

005 第二章 第二节：创建序列 Observable http://t.swift.gg/d/17-005-observable
我们先列出来在 Rx 上有哪几种创建方式：

asObservable 返回一个序列
create 使用 Swift 闭包的方式创建序列
deferred 只有在有观察者订阅时，才去创建序列
empty 创建一个空的序列，只发射一个 .Completed
error 创建一个发射 error 终止的序列
toObservable 使用 SequenceType 创建序列
interval 创建一个每隔一段时间就发射的递增序列
never 不创建序列，也不发送通知
just 只创建包含一个元素的序列。换言之，只发送一个值和 .Completed
of 通过一组元素创建一个序列
range 创建一个有范围的递增序列
repeatElement 创建一个发射重复值的序列
timer 创建一个带延迟的序列

///create
let myTest = { (SingleEvent : Int) -> Observable<Int> in
    return Observable.create({ (observer) -> Disposable in
        observer.onNext(SingleEvent)
        observer.onCompleted()
        return Disposables.create()
    })
}

_ = myTest(5)
    .subscribe({ (event) in
        switch event {
        case .next(let value):
            print(value)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
        }
    })
    ///deferred 只有在观察者订阅时,才去创建序列
let defferredSequence: Observable<Int> = Observable.deferred { () -> Observable<Int> in
    return Observable.create({ (observer) -> Disposable in
        observer.onNext(0)
        observer.onNext(1)
        observer.onNext(4)
        return Disposables.create()
    })
}
_ = defferredSequence
    .subscribe({ (event) in
    print(event)
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
////empty 创建一个空的可观察对象
let emptySequence = Observable<Int>.empty()
_ = emptySequence
    .subscribe({ (event) in
        print(event)
        switch event {
        case .next(let value):
            print(value)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
        }
    })
///error 创建一个发射error终止的序列
let error = NSError(domain: "test", code: -1, userInfo: nil)
let emptySequence = Observable<Int>.error(error)
_ = emptySequence
    .subscribe({ (event) in
//                print(event)
        switch event {
        case .next(let value):
            print(value)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
        }
    })
///interval 创建一个n每隔一段时间就发射的d递增序列
let intervalSequence = Observable<Int>.interval(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance)
_ = intervalSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
/// never 不创建序列,也不发射通知
    let neverSequenece = Observable<Int>.never()
_ = neverSequenece.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
    /// just 只创建包含一个元素的序列,只发送一个值和.completed
let justSequence = Observable<Int>.just(32)
_ = justSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
    ///of  通过一组元素创建一个序列
let ofSequence = Observable<Int>.of(1,2,3,4,5,6,7,8,9)
_ = ofSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
///range 创建一个有范围的递增序列
let rangeSequence = Observable<Int>.range(start: 1, count: 10)
_ = rangeSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
/// 创建一个发射重复值的序列
let repeatSequence = Observable.repeatElement(1)
_ = repeatSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})
///timer 创建一个带延迟序列
let timerSequence = Observable<Int>.timer(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance)
_ = timerSequence.subscribe({ (event) in
    switch event {
    case .next(let value):
        print(value)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
})

006 第二章 第三节：什么是 Subject

我们可以把 Subject 当作一个桥梁（或者说是代理）， Subject 既是 Observable 也是 Observer 。

作为一个 Observer ，它可以订阅序列。
同时作为一个 Observable ，它可以转发或者发射数据。

在这里， Subject 还有一个特别的功能，就是将冷序列变成热序列，订阅后重新发送嘛。

Subject 有以下几种：

PublishSubject 
ReplaySubject
BehaviorSubject
Variable 现在已被废弃// Variable is deprecated. Please use `BehaviorRelay` as a replacement.
BehaviorRelay
1.PublishSubject
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png
当有观察者订阅 PublishSubject 时，PublishSubject 会发射订阅之后的数据给这个观察者。只发射给观察者订阅后的数据
let publishSubject = PublishSubject<String>()
        publishSubject.subscribe { (e) in /// 我们可以在这里看到，这个订阅收到了四个数据
            print("Subscription: 1, event: \(e)")
        }.disposed(by: self.disposeBag)
        publishSubject.on(.next("a"))
        publishSubject.on(.next("b"))
        
        publishSubject.subscribe { (e) in /// 我们可以在这里看到，这个订阅收到了两个数据
            print("Subscription: 2, event \(e)")
        }.disposed(by: self.disposeBag)
        publishSubject.on(.next("c"))
        publishSubject.on(.next("d"))
/// console
Subscription: 1, event: next(a)
Subscription: 1, event: next(b)
Subscription: 1, event: next(c)
Subscription: 2, event next(c)
Subscription: 1, event: next(d)
Subscription: 2, event next(d)

2.ReplaySubject
和 PushblishSubject 不同，不论观察者什么时候订阅， ReplaySubject 都会发射完整的数据给观察者。
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png

let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.subscribe { (e) in
    print("Subscription: 1, event: \(e)")
}.disposed(by: self.disposeBag)
replaySubject.on(.next("a"))
replaySubject.on(.next("b"))

replaySubject.subscribe { (e) in /// 我们可以在这里看到，这个订阅收到了四个数据
    print("Subscription: 2, event \(e)")
}.disposed(by: self.disposeBag)
replaySubject.on(.next("c"))
replaySubject.on(.next("d"))

Subscription: 1, event: next(a)
Subscription: 1, event: next(b) /// 先输出Subscription: 1 的a,b
Subscription: 2, event next(a)  ///当订阅 Subscription: 2 时 a,b 立刻补上
Subscription: 2, event next(b) 
Subscription: 1, event: next(c) // send c 订阅者 1,2 分别处理
Subscription: 2, event next(c)
Subscription: 1, event: next(d) // send d 订阅者1,2 分别处理
Subscription: 2, event next(d)

3.BehaviorSubject
当一个观察者订阅一个 BehaviorSubject ，它会发送原序列最近的那个值（如果原序列还有没发射值那就用一个默认值代替），之后继续发射原序列的值。
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png

let behaviorSubject = BehaviorSubject<String>(value: "z")
behaviorSubject.subscribe { (e) in
    print("Subscription: 1, event: \(e)")
}.disposed(by: self.disposeBag)
behaviorSubject.on(.next("a"))
behaviorSubject.on(.next("b"))

behaviorSubject.subscribe { (e) in 
    print("Subscription: 2, event \(e)")
}.disposed(by: self.disposeBag)
behaviorSubject.on(.next("c"))
behaviorSubject.on(.next("d"))

///console
Subscription: 1, event: next(z)  /// 我们可以在这里看到订阅者1收到next消息a会补上 原序列最近的那个值（如果原序列还有没发射值那就用一个默认值z代替）
Subscription: 1, event: next(a)
Subscription: 1, event: next(b)
Subscription: 2, event next(b) /// 我们可以在这里看到订阅者2收到next消息c会补上 原序列最近的那个值 b
Subscription: 1, event: next(c)
Subscription: 2, event next(c)
Subscription: 1, event: next(d)
Subscription: 2, event next(d)

4.Variable  现在已被废弃用
Variable 是 BehaviorSubject 的一个封装。相比 BehaviorSubject ，它不会因为错误终止也不会正常终止，是一个无限序列。
Variable 是 BehaviorSubject 的一个封装。相比 BehaviorSubject ，它不会因为错误终止也不会正常终止，是一个无限序列。

let variable = Variable("z")
variable.asObservable().subscribe { e in
    print("Subscription: 1, event: \(e)")
    }.addDisposableTo(disposeBag)
variable.value = "a"
variable.value = "b"
variable.asObservable().subscribe { e in
    print("Subscription: 2, event: \(e)")
    }.addDisposableTo(disposeBag)
variable.value = "c"
variable.value = "d"
///log
Subscription: 1, event: next(z)///1一开始的初始化值
Subscription: 1, event: next(a)
Subscription: 1, event: next(b)
Subscription: 2, event: next(b)///2的当前variable的value是b 
Subscription: 1, event: next(c)
Subscription: 2, event: next(c)
Subscription: 1, event: next(d)
Subscription: 2, event: next(d)
Subscription: 1, event: completed
Subscription: 2, event: completed
我们最常用的 Subject 应该就是 Variable 。
Variable 很适合做数据源，比如作为一个 UITableView 的数据源，我们可以在这里保留一个完整的 Array 数据，每一个订阅者都可以获得这个 Array 。
let elements = Variable<[String]>([])
5.BehaviorRelay
let behaviorRelay = BehaviorSubject(value: "z")
behaviorRelay.asObservable().subscribe { e in
    print("Subscription: 1, event: \(e)")
    }.disposed(by: self.disposeBag)
behaviorRelay.on(.next("a"))
behaviorRelay.on(.next("b"))
//        behaviorRelay.value = "b"
behaviorRelay.asObservable().subscribe { e in
    print("Subscription: 2, event: \(e)")
    }.disposed(by: self.disposeBag)
behaviorRelay.on(.next("c"))
behaviorRelay.on(.next("d"))
///log
Subscription: 1, event: next(z)
Subscription: 1, event: next(a)
Subscription: 1, event: next(b)
Subscription: 2, event: next(b)
Subscription: 1, event: next(c)
Subscription: 2, event: next(c)
Subscription: 1, event: next(d)
Subscription: 2, event: next(d)
007 第二章 第四节：变换序列
1.map

下面的这些操作符可以变换一个序列发射的值。这样我们的序列功能就强大了许多，创建，然后进行变换。甚至这里就类似于一条生产线。先做出一个原型，然后再进行各种加工，最后出我们想要的成品。
map 就是用你指定的方法去变换每一个值，这里非常类似 Swift 中的 map ，特别是对 SequenceType 的操作，几乎就是一个道理。一个一个的改变里面的值，并返回一个新的 functor 
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/map.png

let sequence = Observable.of(1,2,3)
sequence.map { (x) -> Int in
    x * 2
}.subscribe { (x) in
    switch x {
    case .next(let value): print(value)
    default: break
    }
}.disposed(by: self.disposeBag)

///console 
2
4
6

2.mapWithIndex(已废弃)    "Please use enumerated().map()"
这是一个和 map 一起的操作，唯一的不同就是我们有了 index ，注意第一个是序列发射的值，第二个是 index 。
已废弃用 enumerated().map()代替
let sequence = Observable.of(1,2,3)
sequence.enumerated().map { (index, element) -> (Int) in
    index * element
}
.subscribe { x in
    switch x {
    case .next(let value): print(value)
    default: break
    }
}.disposed(by: self.disposeBag)

3.flatMap
将一个序列发射的值转换成序列，然后将他们压平到一个序列。这也类似于 SequenceType 中的 flatMap 。
FlatMap将一个发射数据的Observable变换为多个Observables，然后将它们发射的数据合并后放进一个单独的Observable

https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png
let sequenceInt = Observable.of(1,2,3)
let sequenceString = Observable.of("a","b", "c","d","e", "f", "--")
sequenceInt.flatMap { (x:Int) -> Observable<String> in
print("from sequenceint \(x)")

return sequenceString
}.subscribe { x in
    switch x {
    case .next(let value): print(value)
    default: break
    }
}.disposed(by: self.disposeBag)

///console 
from sequenceint 1
a
from sequenceint 2
b
a
from sequenceint 3
c
b
a
d
c
b
e
d
c
f
e
d
--
f
e
--
f
--
4. flatMapLatest
http://reactivex.io/documentation/operators/images/flatMapLatest.png

flatMapFirst 和 flatMapLatest 不同就是 flatMapFisrt 会选择旧的值，抛弃新的。

所以我们在需要总是保持接受最新的数据时（比如网络请求），选择 flatMapLatest 。

 let sequenceInt = Observable.of(1,2,3)
        let sequenceString = Observable.of("a","b", "c","d","e", "f", "--")
        sequenceInt.flatMapLatest{ (x:Int) -> Observable<String> in
            print("from sequenceint \(x)")
            
            return sequenceString
            }.subscribe { x in
                print(x)
                switch x {
                case .next(let value): print(value)
                default: break
                }
            }.disposed(by: self.disposeBag)
///console
from sequenceint 1
next(a)
a
from sequenceint 2
next(a)
a
from sequenceint 3
next(a)
a
next(b)
b
next(c)
c
next(d)
d
next(e)
e
next(f)
f
next(--)
--
completed

5.scan
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/scan.png
应用一个 accumulator (累加) 的方法遍历一个序列，然后返回累加的结果。此外我们还需要一个初始的累加值。实时上这个操作就类似于 Swift 中的 reduce 
let sequenceInt = Observable.of(1,2,3,4,5)
        sequenceInt.scan(100) { (acum, ele) -> Int in
            acum + ele
            }.subscribe { (event) in
                print(event)
                switch event {
                case .next(let value) :print(value)
                default: break
                }
        }.disposed(by: self.disposeBag)
///console 
next(101)
101
next(103)
103
next(106)
106
next(110)
110
next(115)
115
completed

图片就对应了这段代码的意思，每接收到一个值，就和上一次的累加值加起来并发射。这是一个很有趣的功能，你可以参见一下官方的计算器 Demo ，很有意思。记得，这里的 scan 以及 reduce 可不仅仅是只能用来累加，这是一个遍历所有值得过程，所以你可以在这做任何你想做的操作。

6 reduce
和 scan 非常相似，唯一的不同是， reduce 会在序列结束时才发射最终的累加值。就是说，最终只发射一个最终累加值。
let sequenceInt = Observable.of(1,2,3,4,5)
        sequenceInt.reduce(100) { (acum, ele) -> Int in
            acum + ele
            }.subscribe { (event) in
                print(event)
                switch event {
                case .next(let value) :print(value)
                default: break
                }
        }.disposed(by: self.disposeBag)
///log
next(115)
115
completed

7.buffer
在特定的线程，定期定量收集序列发射的值，然后发射这些的值的集合
let sequenceInt = Observable.of(1,2,3,4,5,6)
        sequenceInt
            .buffer(timeSpan: DispatchTimeInterval.seconds(10), count: 2, scheduler: MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                    case .next(let value) : print(value)
                    default: break
                }
            }.disposed(by: self.disposeBag)

(1,2,3,4,5,6)
///log
[1, 2]
[3, 4]
[5, 6]
[]     

(1,2,3,4,5)
///log
[1, 2]
[3, 4]
[5]
为什么会有一个 Next([]) 呢？因为 buffer 并不知道上次的发射的值是最后一个值，只有当收到 Completed 才知道序列已经结束，所以没有缓冲到任何值，只好发射 [] 了
func _synchronized_on(event: Event<E>) {
    switch event {
    case .Next(let element):
        _buffer.append(element)
        
        if _buffer.count == _parent._count {
            startNewWindowAndSendCurrentOne()
        }
        
    case .Error(let error):
        _buffer = []
        forwardOn(.Error(error))
        dispose()
    case .Completed: // 我们只需要关注这个地方~
        forwardOn(.Next(_buffer))
        forwardOn(.Completed)
        dispose()
    }
}
8.window
window 和 buffer 非常类似。唯一的不同就是 window 发射的是序列， buffer 发射一系列值。
http://reactivex.io/documentation/operators/images/window.C.png
let sequenceInt = Observable.of(1,2,3,4,5)
        sequenceInt
            .buffer(timeSpan: DispatchTimeInterval.seconds(10), count: 2, scheduler: MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                    case .next(let value) : print(value)
                    case .completed: print("buffer completed")
                    default: break
                }
            }.disposed(by: self.disposeBag)
        sequenceInt.window(timeSpan: DispatchTimeInterval.seconds(10), count: 2, scheduler: MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                case .next(let value): print(value)
                case .completed: print("window completed")
                default: break
                }
            }.disposed(by: self.disposeBag)
///log      
[1, 2]
[3, 4]
[5]
buffer completed
RxSwift.AddRef<Swift.Int>
RxSwift.AddRef<Swift.Int>
RxSwift.AddRef<Swift.Int>
window completed       

从返回结果可以看到 buffer 返回的序列发射的值是 [Self.E] ，而 window 是 RxSwift.Observable<Self.E> 。

008 第二章 第五节：过滤序列  http://t.swift.gg/d/20-008
过滤 Observable
当我们有了变换操作时，就可以做很多事情了，然而有了过滤操作，对于队列的处理就更加轻松了。
过滤操作就是指去掉我们不喜欢的值，不再继续向下发射我们讨厌的值。
1. filter
filter 应该是最常用的一种过滤操作了。传入一个返回 bool 的闭包决定是否去掉这个值。
 let sequenceInt = Observable.of(1,2,3,4,5,6,7,8,9)
        sequenceInt.filter { (x) -> Bool in
            return x % 2 == 0
            }.subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .completed:print("completed")
                default: break
                }
            }.disposed(by: self.disposeBag)
///log
 2
4
6
8
completed        

2.distinctUntilChanged
阻止发射与上一个重复的值。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
        sequenceInt
            .distinctUntilChanged()
            .subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .completed:print("completed")
                default: break
                }
            }.disposed(by: self.disposeBag)   
///log
1
2
3
4
1
7
8
9
completed
可以看到后半段序列 1 1 7 的第二个 1 被阻止掉了。            
3.take
只发射指定数量的值。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
    sequenceInt
        .take(3)
        .subscribe { (e) in
            switch e {
            case .next(let value): print(value)
            case .completed:print("completed")
            default: break
            }
        }.disposed(by: self.disposeBag)
///log        
1
2
3
completed
可以看到经过 take(3) 之后，只发射了前三个值。
4.takeLast
只发射序列结尾指定数量的值。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
        sequenceInt
            .takeLast(3)
            .subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .completed:print("completed")
                default: break
                }
            }.disposed(by: self.disposeBag)
///log
7
8
9
completed
这里要注意，使用 takeLast 时，序列一定是有序序列，takeLast 需要序列结束时才能知道最后几个是哪几个值。所以 takeLast 会等序列结束才向后发射值。如果你需要舍弃前面的某些值，你需要的是 skip 。

5.skip
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
        sequenceInt
            .skip(3)
            .subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .completed:print("completed")
                default: break
                }
            }.disposed(by: self.disposeBag)
///log
4
1
1
7
8
9
completed
6.debounce/throttle
仅在过了一段指定的时间还没发射数据时才发射一个数据，换句话说就是 debounce 会抑制发射过快的值。注意这一操作需要指定一个线程。来看下面这个例子。

debounce 和 throttle 是同一个东西。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
    sequenceInt
        .debounce(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .subscribe { (e) in
            switch e {
            case .next(let value): print(value)
            case .completed:print("completed")
            default: break
            }
        }.disposed(by: self.disposeBag)
9
completed
可以看到只发射了一个 6 ，因为这个序列发射速度是非常快的，所以过滤掉了前面发射的值。有一个很常见的应用场景，比如点击一个 Button 会请求一下数据，然而总有刁民想去不停的点击，那这个 debounce 就很有用了
7.elementAt
使用 elementAt 就只会发射一个值了，也就是指发射序列指定位置的值，比如 elementAt(2) 就是只发射第二个值。
注意序列的计算也是从 0 开始的。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
        sequenceInt
            .elementAt(2)
            .subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .completed:print("completed")
                default: break
                }
            }.disposed(by: self.disposeBag)
///log
3
completed            
可以看到值发射了一个 3 ，也就是序列的第二个值。这个也有一些应用场景，比如点击几次就如何如何的。
8.single
single 就类似于 take(1) 操作，不同的是 single 可以抛出两种异常： RxError.MoreThanOneElement 和 RxError.NoElements 。当序列发射多于一个值时，就会抛出 RxError.MoreThanOneElement ；当序列没有值发射就结束时， single 会抛出 RxError.NoElements 。
let sequenceInt = Observable.of(1,2,3,4,1,1,7,8,9)
        sequenceInt
            .single()
            .subscribe { (e) in
                switch e {
                case .next(let value): print(value)
                case .error(let error): print(error)
                case .completed:print("completed")
                }
            }.disposed(by: self.disposeBag)
///log
1
Sequence contains more than one element.
9.sample 
sample 就是抽样操作，按照 sample 中传入的序列发射情况进行抽样
如果源数据没有再发射值，抽样序列就不发射，也就是说不会重复抽样。
Observable<Int>.interval(DispatchTimeInterval.milliseconds(10), scheduler: SerialDispatchQueueScheduler(qos: .background))
        .take(100)
        .sample(Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: SerialDispatchQueueScheduler(qos: .background)))
        .subscribe { (e) in
            switch e {
                case .next(let value): print(value)
            case .completed: print("complete")
            case .error(let error) : print(error)
            }
        }.disposed(by: self.disposeBag)
///log
8
18
29
38
49
58
68
78
88
99
complete        
在这个例子中我们使用 interval 创建了每 0.1s 递增的无限序列，同时用 take 只留下前 100 个值。抽样序列是一个每 1s 递增的无限序列。

009 第二章 第六节：组合序列 http://t.swift.gg/d/26-009

1.startWith
在一个序列前插入一个值
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/startwith.png
let sequence = Observable.of(3,4,5,6,7,8)
_ = sequence.startWith(2)
    .startWith(1)
    .subscribe({ (e) in
        switch e {
            case .next(let v): print(v)
            case .error(let error): print(error)
            case .completed: print("completed")
        }
        })
///log
我们可以用这样的方式添加一些默认的数据。当然也可能我们会在末尾添加一些默认数据，这个时候需要使用 concat  
2. combineLatest
当两个序列中的任何一个发射了数据时，combineLatest 会结合并整理每个序列发射的最近数据项。  
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/combinelatest.png
eg.1:let intOb1 = PublishSubject<String>()
        let intOb2 = PublishSubject<Int>()
        _ = Observable.combineLatest(intOb1, intOb2) {
            "(\($0) \($1))"
            }.subscribe{
                print($0)
            }
        intOb1.on(.next("A"))
        intOb2.on(.next(1))
        intOb1.on(.next("B"))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next("C"))
        intOb1.on(.next("D"))
        intOb1.on(.next("E"))
    }
///log     
next((A 1))
next((B 1))
next((B 2))
next((B 3))
next((C 3))
next((D 3))
next((E 3))
可以看到每当有一个序列发射值得时候， combineLatest 都会结合一次发射一个值
需要注意的有两点：
我们都要去传入 resultSelector 这个参数，一般我们做尾随闭包，这个是对两（多）个序列值的处理方式，上面的例子就是将序列一和二的值变成字符串，中间加个空格，外面再包一个() .
Rx 在 combineLatest 上的实现，只能结合 8 个序列。再多的话就要自己去拼接了。
eg.2:
let intOb1 = Observable.just(9)
        let intOb2 = Observable.of(0,1,2,3)
        let intOb3 = Observable.of(4,5,6,7,8)
        
        _ = Observable.combineLatest(intOb1, intOb2, intOb3, resultSelector: { (s: Int, x: Int, y: Int) -> String in
           return "\(s) \(x) \(y)"
        }).subscribe({ (e) in
            print(e)
        })
///log 
next(9 0 4)
next(9 1 4)
next(9 1 5)
next(9 2 5)
next(9 2 6)
next(9 3 6)
next(9 3 7)
next(9 3 8)
completed
eg.3: 
let intOb1 = Observable.just(9)
        let intOb2 = ReplaySubject<Int>.create(bufferSize: 1)
        let intOb3 = Observable.of(4,5,6,7,8)
        intOb2.onNext(1)
        _ = Observable.combineLatest(intOb1, intOb2, intOb3, resultSelector: { (s: Int, x: Int, y: Int) -> String in
           return "\(s) \(x) \(y)"
        }).subscribe({ (e) in
            print(e)
        })
        intOb2.onNext(2)
        intOb2.onNext(3)
///log
next(9 1 4)
next(9 1 5)
next(9 1 6)
next(9 1 7)
next(9 1 8)
next(9 2 8)
next(9 3 8)
3.zip
zip 和 combineLatest 相似，不同的是每当所有序列都发射一个值时， zip 才会发送一个值。它会等待每一个序列发射值，发射次数由最短序列决定。结合的值都是一一对应的。
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/zip.png

let intOb1 = PublishSubject<String>()
        let intOb2 = PublishSubject<Int>()
        intOb2.onNext(1)
        _ = Observable.zip(intOb1, intOb2, resultSelector: { (s: String, x: Int) -> String in
           return "\(s) \(x)"
        }).subscribe({ (e) in
            print(e)
        })
        intOb1.on(.next("A"))
        intOb2.on(.next(1))
        intOb1.on(.next("B"))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next("C"))
        intOb1.on(.next("D"))
        intOb1.on(.next("E"))
///log
next(A 1)
next(B 2)
next(C 3)       
4. merge
merge 会将多个序列合并成一个序列，序列发射的值按先后顺序合并。要注意的是 merge 操作的是序列，也就是说序列发射序列才可以使用 merge 。来看例子
eg.1:let intOb1 = PublishSubject<Int>()
        let intOb2 = PublishSubject<Int>()
        _ = Observable.of(intOb1, intOb2)
            .merge()
            .subscribe {
                print($0)
        }
        intOb1.on(.next(100))
        intOb2.on(.next(1))
        intOb1.on(.next(200))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next(300))
        intOb1.on(.next(400))
        intOb1.on(.next(500))
///log
next(100)
next(1)
next(200)
next(2)
next(3)
next(300)
next(400)
next(500)
eg.2:
 let intOb1 = PublishSubject<Int>()
        let intOb2 = PublishSubject<Int>()
        _ = Observable.of(intOb1, intOb2)
            .merge(maxConcurrent:2)
            .subscribe {
                print($0)
        }
        intOb1.on(.next(100))
        intOb2.on(.next(1))
        intOb1.on(.next(200))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next(300))
        intOb1.on(.next(400))
        intOb1.on(.next(500))
///log
next(100)
next(1)
next(200)
next(2)
next(3)
next(300)
next(400)
next(500)

eg.3
let intOb1 = PublishSubject<Int>()
        let intOb2 = PublishSubject<Int>()
        _ = Observable.of(intOb1, intOb2)
            .merge(maxConcurrent:1)
            .subscribe {
                print($0)
        }
        intOb1.on(.next(100))
        intOb2.on(.next(1))
        intOb1.on(.next(200))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next(300))
        intOb1.on(.next(400))
        intOb1.on(.next(500))
///
next(100)
next(200)
next(300)
next(400)
next(500)
eg.4
let intOb1 = PublishSubject<Int>()
        let intOb2 = PublishSubject<Int>()
        _ = Observable.of(intOb1, intOb2)
            .merge(maxConcurrent:0)
            .subscribe {
                print($0)
        }
        intOb1.on(.next(100))
        intOb2.on(.next(1))
        intOb1.on(.next(200))
        intOb2.on(.next(2))
        intOb2.on(.next(3))
        intOb1.on(.next(300))
        intOb1.on(.next(400))
        intOb1.on(.next(500))
///log 
completed   
merge 可以传递一个 maxConcurrent 的参数，你可以通过传入指定的值说明你想 merge 的最大序列。直接调用 merge() 会 merge 所有序列。你可以试试将这个 merge 2 的例子中的 maxConcurrent 改为 1 ，可以看到 subject2 发射的值都没有被合并进来     

5. switchLatest
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/switch.png
switchLatest 和 merge 有一点相似，都是用来合并序列的。然而这个合并并非真的是合并序列。事实是每当发射一个新的序列时，丢弃上一个发射的序列
let var1 = Variable(0)
        let var2 = Variable(20)
        let var3 = Variable(var1.asObservable())
        let d = var3
                .asObservable()
                .switchLatest()
                .subscribe{print($0)}
        var1.value = 1
        var1.value = 2
        var1.value = 3
        var1.value = 4
        var3.value = var2.asObservable()// 我们在这里新发射了一个序列
        var2.value = 21
        var1.value = 5
        var1.value = 6
        var1.value = 7
///log 
next(0)
next(1)
next(2)
next(3)
next(4)
next(20)
next(21)
completed

///使用BehaviorSubject 替换 Variable
let behaviorRelay1 = BehaviorSubject(value: 0)
        let behaviorRelay2 = BehaviorSubject(value: 20)
        let behaviorRelay3 = BehaviorSubject(value: behaviorRelay1.asObservable())
        let d = behaviorRelay3.asObservable().switchLatest().subscribe { print($0)}
        behaviorRelay1.onNext(1)
        behaviorRelay1.onNext(2)
        behaviorRelay1.onNext(3)
        behaviorRelay1.onNext(4)
        behaviorRelay3.onNext(behaviorRelay2.asObservable())
        behaviorRelay2.onNext(21)
        behaviorRelay1.onNext(5)
        behaviorRelay1.onNext(6)
        behaviorRelay1.onNext(7)
/// log
next(0)
next(1)
next(2)
next(3)
next(4)
next(20)
next(21)        

011 第二章 第八节：错误处理 http://t.swift.gg/d/28-011
虽然只有几个操作符，但 Rx 的错误处理可是比一个 try catch 要方便优美多了。我们可以捕捉错误的同时做一些处理。

1.retry
先来看看 retry ，可能这个操作会比较常用，一般用在网络请求失败时，再去进行请求。
retry 就是失败了再尝试，重新订阅一次序列
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/retry.png
var count = 1
        let s = Observable<Int>.create { (observer) -> Disposable in
            let err = NSError(domain: "Test", code: -1, userInfo: nil)
            observer.onNext(0)
            observer.on(.next(1))
            observer.on(.next(2))
            if count < 2 {
                observer.on(.error(err))
                count += 1
            }
            observer.on(.next(3))
            observer.on(.next(4))
            observer.on(.completed)
            return Disposables.create()
        }
        _ = s.retry().subscribe({ print($0)
        })
///log
next(0)
next(1)
next(2)
next(0)
next(1)
next(2)
next(3)
next(4)
completed       

可以看到这里序列会在第二次（重新）发射时跳过那个 Error 。
来看输出 0 1 2 0 1 2 3 4 5 。可以看到在第一次的 2 后面发送了 Error ，而通过 retry 我们重新订阅了序列，这一次是正常发射的 0 1 2 3 4 5 。
不难发现这里的 retry 会出现数据重复的情况，我推荐 retry 只用在会发射一个值的序列（可能发射 Error 的序列）中。

需要注意的是不加参数的 retry 会无限尝试下去。我们还可以传递一个 Int 值，来说明最多尝试几次。像这样 retry(2) ，最多尝试两次。

2.catchError
当出现 Error 时，用一个新的序列替换。
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/catch.png
想这个理解起来直接看方法声明最好了：

public func catchError(handler: (ErrorType) throws -> RxSwift.Observable<Self.E>) -> RxSwift.Observable<Self.E>

其实就有点类似 flatMap 哈，返回的都是一个序列，想在这里强调 catchError 中你需要传递一个返回序列的闭包。
let s = PublishSubject<Int>()
        let r = Observable.of(100,200,300,400)
        _ = s.catchError({ (error) -> Observable<Int> in
            return r;
        }).subscribe({ (e) in
            print(e)
        })
        s.on(.next(1))
        s.on(.next(2))
        s.on(.error(NSError(domain: "test", code: -1, userInfo: nil)))
        s.on(.next(3))
        s.onCompleted()
///log
next(1)
next(2)
next(100)
next(200)
next(300)
next(400)
completed     
在发射 3 后出现了错误，然后序列被 r 替换继续发射,error后发射的3也无法订阅输出
3.catchErrorJustReturn
就是遇到错误，返回一个值替换这个错误。
let s = PublishSubject<Int>()
        _ = s.catchErrorJustReturn(-1).subscribe({ (err) in
            print(err)
        })
        s.on(.next(1))
        s.on(.next(2))
        s.on(.error(NSError(domain: "test", code: -1, userInfo: nil)))
        s.on(.next(3))
        s.onCompleted()
///log 
next(1)
next(2)
next(-1)
completed        

012 第二章 第九节：其他操作符 http://t.swift.gg/d/29-012

一些实用的操作符
1. SUBSCRIBE
操作序列的发射物和通知， subscribe 系列也就是连接序列和观察者的操作符，顾名思义就是订阅。
/**
     Subscribes an event handler to an observable sequence.
     
     - parameter on: Action to invoke for each event in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func subscribe(_ on: @escaping (RxSwift.Event<Self.Element>) -> Void) -> Disposable

2.doOn ???
注册一个动作作为原始序列生命周期事件的占位符。
http://reactivex.io/documentation/operators/images/do.c.png
你可以把 doOn 理解成在任意的地方插入一个“插队订阅者”，这个“插队订阅者”不会对序列的变换造成任何影响。 doOn 和 subscribe 有很多类似的 API 。

3.takeUntil
当另一个序列开始发射值时，忽略原序列发射的值。
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takeuntil.png
 let originalSequence = PublishSubject<Int>()
        let whenThisSendsNextWorldStops = PublishSubject<Int>()
        
        _ = originalSequence
            .takeUntil(whenThisSendsNextWorldStops)
            .subscribe {
                print($0)
        }
        
        originalSequence.on(.next(1))
        originalSequence.on(.next(2))
        originalSequence.on(.next(3))
        
        whenThisSendsNextWorldStops.on(.next(1))
        
        originalSequence.on(.next(4))
///log
next(1)
next(2)
next(3)
completed

4.takeWhile
根据一个状态判断是否继续向下发射值。这其实类似于 filter 。需要注意的就是 filter 和 takeWhile 什么时候更能清晰表达你的意思，就用哪个。
let sequence = PublishSubject<Int>()
        
        _ = sequence
            .takeWhile { $0 < 3 }
            .subscribe {
                print($0)
        }
        
        sequence.on(.next(1))
        sequence.on(.next(2))
        sequence.on(.next(3))
        
        sequence.on(.next(4))
        
        sequence.on(.next(5))
///log
next(1)
next(2)
completed

5.AMB
在多个源 Observables 中， 取第一个发出元素或产生事件的 Observable，然后只发出它的元素



当你传入多个 Observables 到 amb 操作符时，它将取其中一个 Observable：第一个产生事件的那个 Observable，可以是一个 next，error 或者 completed 事件。 amb 将忽略掉其他的 Observables。
http://reactivex.io/documentation/operators/images/amb.png
let intSequence1 = PublishSubject<Int>()
        let intSequence2 = PublishSubject<Int>()
        
        let _ = intSequence1.amb(intSequence2)
            .subscribe {
                print($0)
        }
        
        intSequence2.onNext(10) // intSequence2 最先发射
        intSequence1.onNext(1)
        intSequence1.onNext(2)
        intSequence2.onNext(20)
///log
next(10)
next(20)

6. CONCAT
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/concat.png
串行的合并多个序列。你可能会想起 switchLatest 操作符，他们有些类似，都是将序列整理到一起。不同的就是 concat 不会在丢弃旧序列的任何一个值。全部按照序列发射的顺序排队发射。
let var1 = BehaviorSubject(value: 0)
        let var2 = BehaviorSubject(value: 200)
        let var3 = BehaviorSubject(value: var1)
        _ = var3.concat().subscribe { (e) in
            print(e)
        }
        var1.on(.next(1))
        var1.on(.next(2))
        var1.on(.next(3))
        var1.on(.next(4))
        var3.on(.next(var2))
        var2.on(.next(201))
        var1.on(.next(5))
        var1.on(.next(6))
        var1.onCompleted()
        var2.on(.next(202))
        var2.on(.next(203))
        var2.on(.next(204))
        var2.onCompleted()
///
next(0)
next(1)
next(2)
next(3)
next(4)
next(5)
next(6)
next(201)
next(202)
next(203)
next(204)
可以看出var3 将var1 和var2 串行的拼接在一起
7.REDUCE        
和 Swift 的 reduce 差不多。只是要记得它和 scan 一样不仅仅只是用来求和什么的。注意和 scan 不同 reduce 只发射一次，真的就和 Swift 的 reduce 相似。还有一个 toArray 的便捷操作，我想你会喜欢
https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/reduce.png
_ = Observable.of(0,1,2,3,4,5,6,7,8,9)
            .reduce(100, accumulator: { (x, y) -> Int in
                x + y
            })
            .subscribe({ (e) in
                print(e)
            })
///log
next(145)
completed
8.delay
将 Observable 的每一个元素拖延一段时间后发出
https://beeth0ven.github.io/RxSwift-Chinese-Documentation/assets/WhichOperator/Operators/delay.png
delay 操作符将修改一个 Observable，它会将 Observable 的所有元素都拖延一段设定好的时间， 然后才将它们发送出来。
let int1 = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        _ = int1
            .subscribe {
                print("first subscription \($0)")
        }
        
        _ = int1
            .delay(DispatchTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe {
                print("second subscription \($0)")
        }
///log
first subscription next(0)
first subscription next(1)
first subscription next(2)
first subscription next(3)
first subscription next(4)
first subscription next(5)
second subscription next(0)
first subscription next(6)
second subscription next(1)
first subscription next(7)
second subscription next(2)
first subscription next(8)
second subscription next(3)
first subscription next(9)
second subscription next(4)
first subscription next(10)        
9. 连接操作 MULTICAST(组播) CONNECT(连)
可连接的序列和一般的序列基本是一样的，不同的就是你可以用可连接序列调整序列发射的时机。只有当你调用 connect 方法时，序列才会发射。比如我们可以在所有订阅者订阅了序列后开始发射。
let s1 = PublishSubject<Int64>()
        _ = s1.subscribe({ (e) in
            print(e)
        })
        let int1 = Observable<Int64>
                    .interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                    .multicast(s1)
        _ = int1
            .subscribe({ (e) in
                print(e)
            })
        _ = int1.connect()
        
        _ = int1.delay(DispatchTimeInterval.seconds(4), scheduler: MainScheduler.instance).subscribe({ (e) in
            print(e)
        })
///log  multicast 将s1和int1连一起
next(0)
next(0)
next(1)
next(1)
next(2)
next(2)
next(3)
next(3)
next(4)
next(4)
next(0)
next(5)
next(5)
next(1)
next(6)
next(6)
next(2)
next(7)
next(7)
next(3)
next(8)
next(8)
next(4)
next(9)
next(9)
next(5)
next(10)
next(10)
next(6)
10.REPLAY  ???
replay 这个操作可以让所有订阅者同一时间收到相同的值。 
就相当于 multicast 中传入了一个 ReplaySubject .
publish = multicast + replaysubject

let int1 = Observable<Int64>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance).replay(0)
        _ = int1.subscribe({ (e) in
            print(e)
        })
        int1.connect().disposed(by: self.disposeBag)
        _ = int1.delay(DispatchTimeInterval.seconds(4), scheduler: MainScheduler.instance)
        _ = int1.delay(DispatchTimeInterval.seconds(6), scheduler: MainScheduler.instance)
///log 
next(0)
next(1)
next(2)
next(3)
next(4)
next(5)
next(6)
next(7)
next(8)
next(9)
next(10)
next(11)
11.PUBLISH ???     


014 第三章 第一节：线程介绍
https://beeth0ven.github.io/RxSwift-Chinese-Documentation/assets/Schedulers/Scheduler.png
使用 subscribeOn 决定订阅者的操作执行在哪个线程
我们用 subscribeOn 来决定数据序列的构建函数在哪个 Scheduler 上运行。例如，由于获取 Data 需要花很长的时间，所以用 subscribeOn 切换到 后台 Scheduler 来获取 Data。这样可以避免主线程被阻塞。
使用 observeOn 指定接下来的操作在哪个线程
我们用 observeOn 来决定在哪个 Scheduler 监听这个数据序列。例如，通过使用 observeOn 方法切换到主线程来监听并且处理结果。
一个比较典型的例子就是，在后台发起网络请求，然后解析数据，最后在主线程刷新页面。你就可以先用 subscribeOn 切到后台去发送请求并解析数据，最后用 observeOn 切换到主线程更新页面

let s1 = Observable.of(1,2,3,4,5,6,7,8,9).observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (n) -> Void in
                let thread = Thread.current
               print("\(n) 在\(thread) background scheduler 执行 \n")
            })
            .observeOn(MainScheduler.instance)
            .map({ (n) -> Void in
                let thread = Thread.current
                print("\(n) + \(thread) 在 main scheduler")
            })
        _ = s1.subscribe({ (e) in
            print(e)
        })
///log
1 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

2 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

3 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

4 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

5 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

6 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

7 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

8 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

9 在<NSThread: 0x60000088ce40>{number = 3, name = (null)} background scheduler 执行 

() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
() + <NSThread: 0x600000809f80>{number = 1, name = main} 在 main scheduler
next(())
completed        

015 第三章 第二节：线程切换 http://t.swift.gg/d/31-015
1.MainScheduler 串行
在 Rx 中我们已经有主线程切换的姿势：

.observeOn(MainScheduler.instance)
这样就切换到了主线程~

MainScheduler 有一个很有用的功能：

public class func ensureExecutingOnScheduler() 
你可以在需要保证代码一定执行在主线程的地方调用 MainScheduler.ensureExecutingOnScheduler() ，特别是在线程切换来切换去的情况下，或者是调用其他的库，我们不确定当前是否在执行在主线程。毕竟 UI 的更新还是要在主线程执行的。
2.SerialDispatchQueueScheduler 串行
在继续后面的内容我们不得不先提到 SerialDispatchQueueScheduler ，这个就是一个串行的调度器，上面的 MainScheduler 就是继承的这个。
3.DISPATCHQUEUESCHEDULERQOS
iOS 8 新增加了 QOS ，分别有以下五种等级：

QOS_CLASS_USER_INTERACTIVE
QOS_CLASS_USER_INITIATED
QOS_CLASS_DEFAULT
QOS_CLASS_UTILITY
QOS_CLASS_BACKGROUND
在 Rx 中，我们用 enum 创建了 DispatchQueueSchedulerQOS ：

public enum DispatchQueueSchedulerQOS {
    case UserInteractive
    case UserInitiated
    case Default
    case Utility
    case Background
}
和上面的等级是一一对应的。

用 QOS 创建一个 DispatchQueueSchedulerQOS 非常方便：

public convenience init(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS, internalSerialQueueName: String = "rx.global_dispatch_queue.serial")
用一个初始化就 OK ：

4.SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
我更推荐你使用已有的 QOS 管理多线程问题，毕竟这是一个线程等级更明确的方案。即便是创建自己的 GCD 我也建议直接使用 SerialDispatchQueueScheduler ，毕竟自己再去实现那些协议很麻烦不是吗？

你也可以通过以下两种方式创建自己的 GCD ：

public convenience init(internalSerialQueueName: String, serialQueueConfiguration: ((dispatch_queue_t) -> Void)? = nil)

public convenience init(queue: dispatch_queue_t, internalSerialQueueName: String)
还有一点，MainScheduler 是继承 SerialDispatchQueueScheduler 的。
5.ConcurrentDispatchQueueScheduler 并行
同样我们还有一个并行的 Scheduler ：ConcurrentDispatchQueueScheduler 。

API 的使用和 SerialDispatchQueueScheduler 是一样的。
6.OperationQueueScheduler 并行
使用 NSOperationQueue 最大的好处就是我们可以很方便的定制最大并发线程数量，即设置 maxConcurrentOperationCount 。
创建方法也很简单，只需要传入一个 NSOperationQueue 。

019 第四章 第一节 RxCocoa 的 API http://t.swift.gg/d/33-019-rxcocoa-api
只有 RxSwift 并不能让我们直接拿来进行快速开发，我们需要 RxCocoa 。
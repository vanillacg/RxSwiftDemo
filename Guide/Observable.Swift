概述
在ReactiveX中，一个观察者(Observer)订阅一个可观察对象(Observable)。观察者对Observable发射的数据或数据序列作出响应。这种模式可以极大地简化并发操作，因为它创建了一个处于待命状态的观察者哨兵，在未来某个时刻响应Observable的通知，不需要阻塞等待Observable发射数据。

创建观察者
本文使用类似于Groovy的伪代码举例，但是ReactiveX有多种语言的实现。

普通的方法调用（不是某种异步方法，也不是Rx中的并行调用），流程通常是这样的：

调用某一个方法
用一个变量保存方法返回的结果
使用这个变量和它的新值做些有用的事
用代码描述就是：

// make the call, assign its return value to `returnVal`
returnVal = someMethod(itsParameters);
// do something useful with returnVal

在异步模型中流程更像这样的：

定义一个方法，这个方法拿着某个异步调用的返回值做一些有用的事情。这个方法是观察者的一部分。
将这个异步调用本身定义为一个Observable
观察者通过订阅(Subscribe)操作关联到那个Observable
继续你的业务逻辑，等方法返回时，Observable会发射结果，观察者的方法会开始处理结果或结果集
用代码描述就是：


// defines, but does not invoke, the Subscriber's onNext handler
// (in this example, the observer is very simple and has only an onNext handler)
def myOnNext = { it -> do something useful with it };
// defines, but does not invoke, the Observable
def myObservable = someObservable(itsParameters);
// subscribes the Subscriber to the Observable, and invokes the Observable
myObservable.subscribe(myOnNext);
// go on about my business

回调方法 (onNext, onCompleted, onError)

取消订阅 (Unsubscribing)
有一个特殊的观察者接口Subscriber，它有一个unsubscribe方法。调用这个方法表示你不关心当前订阅的Observable了，因此Observable可以选择停止发射新的数据项（如果没有其它观察者订阅）。
取消订阅的结果会传递给这个Observable的操作符链，而且会导致这个链条上的每个环节都停止发射数据项。这些并不保证会立即发生，然而，对一个Observable来说，即使没有观察者了，它也可以在一个while循环中继续生成并尝试发射数据项

Observables的"热"和"冷"
Observable什么时候开始发射数据序列？这取决于Observable的实现，一个"热"的Observable可能一创建完就开始发射数据，因此所有后续订阅它的观察者可能从序列中间的某个位置开始接受数据（有一些数据错过了）。一个"冷"的Observable会一直等待，直到有观察者订阅它才开始发射数据，因此这个观察者可以确保会收到整个数据序列。
在一些ReactiveX实现里，还存在一种被称作Connectable的Observable，不管有没有观察者订阅它，这种Observable都不会开始发射数据，除非Connect方法被调用。


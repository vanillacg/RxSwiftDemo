# Swift 闭包表达式语法

一般形式:

```swift
{ (parameters) -> return type in
    statements
}

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames 为 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]

//等价于
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

```

##### 根据上下文推断类型

因为排序闭包函数是作为 `sorted(by:)` 方法的参数传入的，Swift 可以推断其参数和返回值的类型。`sorted(by:)` 方法被一个字符串数组调用，因此其参数必须是 `(String, String) -> Bool` 类型的函数。这意味着 `(String, String)` 和 `Bool` 类型并不需要作为闭包表达式定义的一部分。因为所有的类型都可以被正确推断，返回箭头（`->`）和围绕在参数周围的括号也可以被省略：

```swift
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
```

```swift
///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]
```

实际上，通过内联闭包表达式构造的闭包作为参数传递给函数或方法时，总是能够推断出闭包的参数和返回值类型。这意味着闭包作为函数或者方法的参数时，你几乎不需要利用完整格式构造内联闭包。

##### 单表达式闭包的隐式返回

单行表达式闭包可以通过省略 `return` 关键字来隐式返回单行表达式的结果，如上版本的例子可以改写为：

```swift
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

在这个例子中，`sorted(by:)` 方法的参数类型明确了闭包必须返回一个 `Bool` 类型值。因为闭包函数体只包含了一个单一表达式（`s1 > s2`），该表达式返回 `Bool` 类型值，因此这里没有歧义，`return` 关键字可以省略。

##### 参数名称缩写

Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 `$0`，`$1`，`$2` 来顺序调用闭包的参数，以此类推。

如果你在闭包表达式中使用参数名称缩写，你可以在闭包定义中省略参数列表，并且对应参数名称缩写的类型会通过函数类型进行推断。`in` 关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构
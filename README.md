# FLite

## FluentSQLiteDriver --> F + Lite -- > FLite

### Example Uses:

#### FLite.main
```swift
// Use FLite.main
//  Default Storage Type: Memory

try? FLite.prepare(migration: Todo.self).wait()

try! FLite.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

FLite.fetch(model: Todo.self)
    .whenSuccess { (values) in
        print(values)
}
```

#### FLite.init(...)
```swift
// Create your own FLite

let flite = FLite(threads: 30,
                  configuration: .sqlite(.memory, maxConnectionsPerEventLoop: 30),
                  id: .sqlite,
                  logger: Logger(label: "Custom.FLITE"))

try? flite.prepare(migration: Todo.self).wait()

try! flite.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

flite.fetch(model: Todo.self)
    .whenSuccess { (values) in
        print(values)
}
```

## GitHub Supporters

 [<img class="avatar" alt="suzyfendrick" src="https://avatars1.githubusercontent.com/u/25371717?s=460&u=34217047bbfd4912909cd5a85959544b6e49cc9f&v=4" width="72" height="72">](https://github.com/suzyfendrick)

# FLite

## FluentSQLiteDriver --> F + Lite -- > FLite

### Example Uses:

#### FLite.main
```swift
// Use FLite.memory
//  Default Storage Type: Memory

try? FLite.memory.prepare(migration: Todo.self).wait()

try! FLite.memory.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

FLite.memory.all(model: Todo.self)
    .whenSuccess { (todos) in
        print(values)
}
```

#### FLite.init(...)
```swift
// Create your own FLite

let persist = FLite(configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite"), loggerLabel: "persisted-FLITE")

try? persist.prepare(migration: Todo.self).wait()

try! persist.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

persist.all(model: Todo.self)
    .whenSuccess { (values) in
        print(values)
}
```

## GitHub Supporters

 [<img class="avatar" alt="suzyfendrick" src="https://avatars1.githubusercontent.com/u/25371717?s=460&u=34217047bbfd4912909cd5a85959544b6e49cc9f&v=4" width="72" height="72">](https://github.com/suzyfendrick)

# FLite

## FluentSQLiteDriver --> F + Lite -- > FLite

FLite uses [Fluent](https://docs.vapor.codes/4.0/fluent/overview/)'s [FluentSQLiteDriver](https://github.com/vapor/fluent-sqlite-driver.git) from Vapor
> Fluent is an ORM framework for Swift. It takes advantage of Swift's strong type system to provide an easy-to-use interface for your database. Using Fluent centers around the creation of model types which represent data structures in your database. These models are then used to perform create, read, update, and delete operations instead of writing raw queries.
> 
> Excerpt from: Vapor Docs. https://docs.vapor.codes/4.0/fluent/overview/

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

# FLite

FluentSQLite --> F + Lite -- > FLite

Example Use:

```
// Use FLite.main
//  Default Storage Type: Memory

try? FLite.prepare(migration: Todo.self).wait()

try! FLite.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

FLite.fetch(model: Todo.self)
    .whenSuccess { (values) in
        print(values)
}

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

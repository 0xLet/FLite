# FLite

FluentSQLite --> F + Lite -- > FLite

Example Use:

```
FLite.storage = .memory

FLite.prepare(model: Todo.self)
        
FLite.create(model: Todo(title: "Hello World"))

FLite.fetch(model: Todo.self) { values in
    print(values)
}
```

## GitHub Supporters

 [<img class="avatar" alt="suzyfendrick" src="https://avatars1.githubusercontent.com/u/25371717?s=460&u=34217047bbfd4912909cd5a85959544b6e49cc9f&v=4" width="72" height="72">](https://github.com/suzyfendrick)

# FLite

FluentSQLite --> F + Lite -- > FLite

Example Use:

```
FLite.prepare(model: Todo.self)
        
FLite.create(model: Todo(title: "Hello World"))

FLite.fetch(model: Todo.self) { values in
    print(values)
}
```

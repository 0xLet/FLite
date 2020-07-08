import Foundation
import FluentSQLiteDriver

internal final class Todo: Model {
    init() { }
    
    static let schema: String = "todos"
    
    /// The unique identifier for this `Todo`.
    @ID(key: .id)
    var id: UUID?

    /// A title describing what this `Todo` entails.
    @Field(key: "title")
    var title: String
    
    @Field(key: "someList")
    var someList: [String]

    /// Creates a new `Todo`.
    init(id: UUID? = nil, title: String, strings: [String]) {
        self.id = id
        self.title = title
        self.someList = strings
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .id()
            .field("title", .string, .required)
            .field("someList", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema).delete()
    }
}
extension Todo: CustomStringConvertible {
    var description: String {
        return """
        Todo id: \(id)
            title: \(title)
            someList: \(someList)
        """
    }
}

// A Todo list.
internal final class TodoList: Model {
    init() { }
    
    static var schema: String = "todolist"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "items")
    var items: [Todo]

    /// Creates a new `Todo`.
    init(id: UUID? = nil, title: String, items: [Todo]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

/// Allows `TodoList` to be used as a dynamic migration.
extension TodoList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TodoList.schema)
            .id()
            .field("title", .string, .required)
            .field("items", .array(of: .custom(Todo.self)), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TodoList.schema).delete()
    }
}

extension TodoList: CustomStringConvertible {
    var description: String {
        return """
        TodoList id: \(id)
            title: \(title)
            items: \(items)
        """
    }
}

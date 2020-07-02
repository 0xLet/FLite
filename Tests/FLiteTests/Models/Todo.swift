import FluentSQLite
/// A single entry of a Todo list.
internal final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String
    
    var someList: [String]

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, strings: [String]) {
        self.id = id
        self.title = title
        self.someList = strings
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }
extension Todo: CustomStringConvertible { 
    var description: String {
        return """
        Todo id: \(id ?? -1)
            title: \(title)
            someList: \(someList)
        """
    }
}

// A Todo list.
internal final class TodoList: SQLiteModel {
    var id: Int?

    var title: String
    
    var items: [Todo]

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, items: [Todo]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

/// Allows `TodoList` to be used as a dynamic migration.
extension TodoList: Migration { }
extension TodoList: CustomStringConvertible {
    var description: String {
        return """
        TodoList id: \(id ?? -1)
            title: \(title)
            items: \(items)
        """
    }
}

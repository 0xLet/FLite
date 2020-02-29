import FluentSQLite

public struct FLite {
    public static var storage: SQLiteStorage = .memory {
        didSet {
            FLite.manager = SQLiteDatabaseManager(storage: FLite.storage)
        }
    }
    public static var manager = SQLiteDatabaseManager(storage: FLite.storage)
}

public extension FLite {
    static var connection: EventLoopFuture<SQLiteConnection> {
        return FLite.manager.connection
    }
    
    static func prepare<T: Migration>(model: T.Type,
                                      onError: @escaping (Error) -> () = { print($0) },
                                      onComplete: @escaping () -> Void) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.prepare(on: connection)
                .catchMap(onError)
                .whenSuccess(onComplete)
        }
    }
    
    static func prepare<T: Migration>(model: T.Type) -> EventLoopFuture<Void> where T: SQLiteModel {
        return FLite.connection.then { connection in
            model.prepare(on: connection)
        }
    }
    
    static func create<T: Migration>(model: T,
                                     onError: @escaping (Error) -> () = { print($0) },
                                     onComplete: @escaping (T) -> Void) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.save(on: connection)
                .catch(onError)
                .whenSuccess(onComplete)
        }
    }
    
    static func create<T: Migration>(model: T) -> EventLoopFuture<T> where T: SQLiteModel {
        return FLite.connection.then { (connection) in
            model.save(on: connection)
        }
    }
    
    static func fetchAll<T: Migration>(model: T.Type,
                                    onError: @escaping (Error) -> () = { print($0) },
                                    onComplete: @escaping ([T]) -> Void) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.query(on: connection).all()
                .catch(onError)
                .whenSuccess(onComplete)
        }
    }
    
    static func fetchAll<T: Migration>(model: T.Type) -> EventLoopFuture<[T]> where T: SQLiteModel {
        return FLite.connection.then { (connection) in
            model.query(on: connection).all()
        }
    }
    
    static func fetch<T: Migration>(model: T.Type) -> EventLoopFuture<QueryBuilder<SQLiteDatabase, T>> where T: SQLiteModel {
        return FLite.connection.map { (connection) in
            model.query(on: connection)
        }
    }
}

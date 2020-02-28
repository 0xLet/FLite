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
        return FLite.manager.pool.requestConnection()
    }
    
    static func prepare<T: Migration>(model: T.Type,
                                      onError: @escaping (Error) -> () = { print($0) },
                                      onComplete: @escaping () -> Void = {}) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.prepare(on: connection)
                .catchMap(onError)
                .whenComplete(onComplete)
        }
    }
    
    static func create<T: Migration>(model: T,
                                     
                                     onError: @escaping (Error) -> () = { print($0) },
                                     onComplete: @escaping () -> Void = {}) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.save(on: connection)
                .catch(onError)
                .whenComplete(onComplete)
        }
    }
    
    static func fetch<T: Migration>(model: T.Type,
                                    onError: @escaping (Error) -> () = { print($0) },
                                    onComplete: @escaping ([T]) -> Void = { _ in }) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.query(on: connection).all()
                .catch(onError)
                .whenSuccess(onComplete)
        }
    }
}

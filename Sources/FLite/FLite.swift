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
    
    static func prepare<T: Migration>(model: T.Type, onComplete: (() -> Void)? = nil) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.prepare(on: connection).whenComplete {
                onComplete?()
            }
        }
    }
    
    static func create<T: Migration>(model: T, onComplete: (() -> Void)? = nil) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.save(on: connection).whenComplete {
                onComplete?()
            }
        }
    }
    
    static func fetch<T: Migration>(model: T.Type, onComplete: (([T]) -> Void)? = nil) where T: SQLiteModel {
        FLite.connection.whenSuccess { (connection) in
            model.query(on: connection).all().whenSuccess { values in
                onComplete?(values)
            }
        }
    }
}

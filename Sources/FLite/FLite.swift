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
    static func connection(withHandler handler: @escaping (SQLiteConnection) -> Void,
                    completionHandler completion: @escaping () -> Void) {
        FLite.manager.connection(withHandler: handler,
                                 completionHandler: completion)
    }
    
    static func prepare<T: Migration>(model: T.Type,
                                      onError: @escaping (Error) -> () = { print($0) },
                                      onComplete: @escaping () -> Void) where T: SQLiteModel {
        FLite.connection(withHandler: { (connection) in
            model.prepare(on: connection)
            .catchMap(onError)
            .whenSuccess(onComplete)
        }) {}
    }
    
    static func create<T: Migration>(model: T,
                                     onError: @escaping (Error) -> () = { print($0) },
                                     onComplete: @escaping (T) -> Void) where T: SQLiteModel {
        FLite.connection(withHandler: { (connection) in
            model.save(on: connection)
            .catch(onError)
            .whenSuccess(onComplete)
        }) {}
    }
    
    static func fetchAll<T: Migration>(model: T.Type,
                                    onError: @escaping (Error) -> () = { print($0) },
                                    onComplete: @escaping ([T]) -> Void) where T: SQLiteModel {
        FLite.connection(withHandler: { (connection) in
            model.query(on: connection).all()
            .catch(onError)
            .whenSuccess(onComplete)
        }) {}
    }
    
    static func fetch<T: Migration>(model: T.Type,
                                    qb: @escaping (QueryBuilder<SQLiteDatabase, T>) -> Void) where T: SQLiteModel {
        FLite.manager.connection(withHandler: { (connection) in
            qb(model.query(on: connection))
        }, completionHandler: {})
    }
}

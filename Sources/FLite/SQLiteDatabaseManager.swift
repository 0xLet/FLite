//
//  SQLiteDatabaseManager.swift
//  
//
//  Created by 0xLeif on 2/27/20.
//
import FluentSQLite

public struct SQLiteDatabaseManager {
    private let db: SQLiteDatabase
    private let container: BasicContainer
    private let databases: Databases
    private var group: MultiThreadedEventLoopGroup
    private var identifier: DatabaseIdentifier<SQLiteDatabase>
    private var config: DatabasesConfig
    fileprivate var pool: DatabaseConnectionPool<ConfiguredDatabase<SQLiteDatabase>>
    
    public init(storage: SQLiteStorage = .memory,
         id: DatabaseIdentifier<SQLiteDatabase> = "default",
         numberOfThreads: Int = 1,
         maxConnections: Int = 10) {
        self.db = try! SQLiteDatabase(storage: storage)
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
        self.identifier = id
        self.config = DatabasesConfig()
        config.add(database: db, as: identifier)
        self.container = BasicContainer(config: .init(), environment: .testing, services: .init(), on: group)
        self.databases = try! config.resolve(on: container)
        self.pool = try! databases.requireDatabase(for: identifier)
        .newConnectionPool(config: .init(maxConnections: maxConnections), on: self.group)
    }
}

public extension SQLiteDatabaseManager {
    var connection: EventLoopFuture<SQLiteConnection> {
        return pool.requestConnection()
    }

    mutating func set(id: DatabaseIdentifier<SQLiteDatabase>) {
        self.identifier = id
    }
    
    mutating func set(numberOfThreads: Int)  {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
    }

    
    mutating func set(maxConnections: Int)  {
        self.pool = try! databases.requireDatabase(for: identifier)
        .newConnectionPool(config: .init(maxConnections: maxConnections), on: self.group)
    }
}
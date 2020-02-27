//
//  SQLiteDatabaseManager.swift
//  
//
//  Created by 0xLeif on 2/27/20.
//
import FluentSQLite

public struct SQLiteDatabaseManager {
    private let db: SQLiteDatabase
    private let group: MultiThreadedEventLoopGroup
    private let identifier: DatabaseIdentifier<SQLiteDatabase>
    private var config: DatabasesConfig
    private let container: BasicContainer
    private let databases: Databases
    public var pool: DatabaseConnectionPool<ConfiguredDatabase<SQLiteDatabase>>
    
    init(storage: SQLiteStorage = .memory, id: DatabaseIdentifier<SQLiteDatabase> = "default") {
        self.db = try! SQLiteDatabase(storage: storage)
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.identifier = id
        self.config = DatabasesConfig()
        config.add(database: db, as: identifier)
        self.container = BasicContainer(config: .init(), environment: .testing, services: .init(), on: group)
        self.databases = try! config.resolve(on: container)
        self.pool = try! databases.requireDatabase(for: identifier).newConnectionPool(config: .init(maxConnections: 20), on: self.group)
    }
}

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
    private let test: DatabaseIdentifier<SQLiteDatabase>
    private var config: DatabasesConfig
    private let container: BasicContainer
    private let databases: Databases
    public let pool: DatabaseConnectionPool<ConfiguredDatabase<SQLiteDatabase>>
    
    init() {
//        guard let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            fatalError("Could not file 'documentDirectory'")
//        }
        
        self.db = try! SQLiteDatabase(storage:
            .memory
//            .file(path: "\(filePath)/default.sqlite")
        )
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.test = "test"
        self.config = DatabasesConfig()
        config.add(database: db, as: test)
        self.container = BasicContainer(config: .init(), environment: .testing, services: .init(), on: group)
        self.databases = try! config.resolve(on: container)
        self.pool = try! databases.requireDatabase(for: test).newConnectionPool(config: .init(maxConnections: 20), on: self.group)
    }
}

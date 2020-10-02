import FluentSQLiteDriver
import NIO

public class FLite {
    // MARK: Private Values
    
    private var group: EventLoopGroup!
    private var pool: NIOThreadPool!
    private var dbs: Databases!
    private var log: Logger!
    
    // MARK: deinit
    
    deinit {
        destory()
    }
    
    // MARK: Calculated Values
    
    private var db: Database {
        dbs.database(logger: log, on: dbs.eventLoopGroup.next())!
    }
    
    public static var memory: FLite = FLite(loggerLabel: "FLITE")
    
    // MARK: init
    
    public init(
        configuration: SQLiteConfiguration = .init(storage: .memory),
        loggerLabel: String
    ) {
        let threads = System.coreCount
        
        group = MultiThreadedEventLoopGroup(numberOfThreads: threads)
        
        pool = .init(numberOfThreads: threads)
        pool.start()
        
        dbs = Databases(threadPool: pool, on: group)
        dbs.use(.sqlite(configuration), as: .sqlite)
        
        log = Logger(label: loggerLabel)
    }
    
    public init(
        eventGroup: EventLoopGroup,
        threadPool: NIOThreadPool,
        configuration: DatabaseConfigurationFactory,
        id: DatabaseID,
        logger: Logger
    ) {
        group = eventGroup
        pool = threadPool
        
        pool.start()
        
        dbs = Databases(threadPool: pool, on: group)
        dbs.use(configuration, as: id)
        
        log = logger
    }
    
    public init(
        threads: Int,
        configuration: DatabaseConfigurationFactory,
        id: DatabaseID,
        logger: Logger
    ) {
        group = MultiThreadedEventLoopGroup(numberOfThreads: threads)
        
        pool = .init(numberOfThreads: threads)
        pool.start()
        
        dbs = Databases(threadPool: pool, on: group)
        dbs.use(configuration, as: id)
        
        log = logger
    }
    
    // MARK: Database Functions
    
    public func prepare(migration: Migration) -> EventLoopFuture<Void> {
        migration.prepare(on: db)
    }
    
    public func prepare<T: Migration & Model>(migration: T.Type) -> EventLoopFuture<Void> {
        migration.init().prepare(on: db)
    }
    
    public func add<T: Model>(model: T) -> EventLoopFuture<Void> {
        model.save(on: db)
    }
    
    public func update<T: Model>(model: T) -> EventLoopFuture<Void> {
        model.update(on: db)
    }
    
    public func query<T: Model>(model: T.Type) -> QueryBuilder<T> {
        db.query(model)
    }
    
    public func all<T: Model>(model: T.Type) -> EventLoopFuture<[T]> {
        db.query(model).all()
    }
    
    public func shutdown() {
        dbs.shutdown()
    }
    
    private func destory() {
        shutdown()
        dbs = nil
        
        do {
            try pool.syncShutdownGracefully()
        } catch {
            pool.shutdownGracefully { [weak self] in
                self?.log.error("(NIOThreadPool) Shutting Down with Error: \($0.debugDescription)")
            }
        }
        pool = nil
        
        do {
            try group.syncShutdownGracefully()
        } catch {
            group.shutdownGracefully { [weak self] in
                self?.log.error("(EventLoopGroup) Shutting Down with Error: \($0.debugDescription)")
            }
        }
        group = nil
    }
}

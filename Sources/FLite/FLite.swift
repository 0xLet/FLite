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
        shutdown()
    }
    
    // MARK: Calculated Values
    
    private var db: Database {
        dbs.database(logger: log, on: dbs.eventLoopGroup.next())!
    }
    
    public static var main: FLite = FLite()
    
    // MARK: init
    
    // Private
    
    private init() {
        let threads = System.coreCount
        
        group = MultiThreadedEventLoopGroup(numberOfThreads: threads)
        
        pool = .init(numberOfThreads: threads)
        pool.start()
        
        dbs = Databases(threadPool: pool, on: group)
        dbs.use(.sqlite(.memory), as: .sqlite)
        
        log = Logger(label: "FLITE")
    }
    
    // Public
    
    public init(eventGroup: EventLoopGroup,
                threadPool: NIOThreadPool,
                configuration: DatabaseConfigurationFactory,
                id: DatabaseID,
                logger: Logger) {
        group = eventGroup
        pool = threadPool
        
        pool.start()
        
        dbs = Databases(threadPool: pool, on: group)
        dbs.use(configuration, as: id)
        
        log = logger
    }
    
    public init(threads: Int,
                configuration: DatabaseConfigurationFactory,
                id: DatabaseID,
                logger: Logger) {
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
    
    public func fetch<T: Model>(model: T.Type) -> EventLoopFuture<[T]> {
        db.query(model).all()
    }
    
    public func shutdown() {
        dbs.shutdown()
        dbs = nil
        
        do {
            try pool.syncShutdownGracefully()
        } catch {
            pool.shutdownGracefully {
                print("(NIOThreadPool) Shutting Down with Error: \($0.debugDescription)")
            }
        }
        pool = nil
        
        do {
            try group.syncShutdownGracefully()
        } catch {
            group.shutdownGracefully {
                print("(EventLoopGroup) Shutting Down with Error: \($0.debugDescription)")
            }
        }
        group = nil
    }
    
    // MARK: Static Database Functions
    
    public static func prepare(migration: Migration) -> EventLoopFuture<Void> {
        FLite.main.prepare(migration: migration)
    }
    
    public static func prepare<T: Migration & Model>(migration: T.Type) -> EventLoopFuture<Void> {
        FLite.main.prepare(migration: migration)
    }
    
    public static func add<T: Model>(model: T) -> EventLoopFuture<Void> {
        FLite.main.add(model: model)
    }
    
    public static func update<T: Model>(model: T) -> EventLoopFuture<Void> {
        FLite.main.update(model: model)
    }
    
    public static func query<T: Model>(model: T.Type) -> QueryBuilder<T> {
        FLite.main.query(model: model)
    }
    
    public static func fetch<T: Model>(model: T.Type) -> EventLoopFuture<[T]> {
        FLite.main.query(model: model).all()
    }
    
    public static func shutdown() {
        FLite.main.dbs.shutdown()
    }
}

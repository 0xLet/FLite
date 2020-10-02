import XCTest
import FluentSQLiteDriver
@testable import FLite

final class FLiteTests: XCTestCase {
    override func tearDown() {
        FLite.memory.shutdown()
    }
    
    func testExample() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = [Todo]()
        
        try? FLite.memory.prepare(migration: Todo.self).wait()
        
        try! FLite.memory.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()
        
        FLite.memory.all(model: Todo.self)
            .whenSuccess { (todos) in
                values = todos
                semaphore.signal()
        }
        
        semaphore.wait()
        XCTAssert(values.count > 0)
    }
    
    func testCustomFLite() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = [Todo]()
        
        let flite = FLite(threads: 30,
                          configuration: .sqlite(.memory, maxConnectionsPerEventLoop: 30),
                          id: .sqlite,
                          logger: Logger(label: "Custom.FLITE"))
        
        try? flite.prepare(migration: Todo.self).wait()
        
        try! flite.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()
        
        flite.all(model: Todo.self)
            .whenSuccess { (todos) in
                values = todos
                semaphore.signal()
        }
        
        semaphore.wait()
        XCTAssert(values.count > 0)
    }
    
    func testTodoArray() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = (0 ..< 500).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 10000))", strings: []) }
        
        try? FLite.memory.prepare(migration: Todo.self).wait()
        
        values.forEach { value in
            try! FLite.memory.add(model: value).wait()
        }
        
        FLite.memory.all(model: Todo.self)
            .whenSuccess { (todos) in
                values = todos
                semaphore.signal()
        }
        
        semaphore.wait()
        XCTAssert(values.count > 0)
        XCTAssertEqual(values.count, 500)
    }
    
    func testTodoList_big() {
        let semaphore = DispatchSemaphore(value: 0)
        var bigList: TodoList?
        
        try? FLite.memory.prepare(migration: Todo.self).wait()
        try? FLite.memory.prepare(migration: TodoList.self).wait()
        
        let list = TodoList(title: "First", items: (0 ..< 100_000).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 100_000))", strings: ["1", "two", "111"]) })
        
        try! FLite.memory.add(model: list).wait()
        try! FLite.memory.add(model: TodoList(title: "BIG", items: (0 ..< 1_000_000).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 1_000_000))", strings: []) })).wait()
        
        FLite.memory.query(model: TodoList.self).filter("title", .equal, "BIG").first().whenSuccess {
            bigList = $0
            semaphore.signal()
        }
        
        semaphore.wait()
        
        XCTAssertEqual(bigList?.items.count, 1_000_000)
    }
    
    static var allTests = [
        ("testExample", testExample),
        ("testTodoArray", testTodoArray),
        ("testTodoList_big", testTodoList_big)
    ]
}

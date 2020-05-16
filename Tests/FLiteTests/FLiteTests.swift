import XCTest
import FluentSQLite
@testable import FLite


final class FLiteTests: XCTestCase {
    func testExample() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = [Todo]()
        
        FLite.storage = .memory
        
        FLite.prepare(model: Todo.self) {
            "Prepared".log()
        }
        
        FLite.create(model: Todo(title: "Hello World", strings: ["hello", "world"])) {
            "Created: \($0)".log()
        }
        
        FLite.fetch(model: Todo.self) { qb in
            qb.all()
                .whenSuccess {
                    "Values: \($0)".log()
                    values = $0
                    semaphore.signal()
            }
        }
        
        semaphore.wait()
        XCTAssert(values.count > 0)
    }
    
    func testTodoArray() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = (0 ..< 500).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 10000))", strings: []) }
        
        FLite.storage = .memory
        
        FLite.manager.set(maxConnections: 100)
        
        FLite.manager.set(id: "Something Else")
        
        FLite.prepare(model: Todo.self) {
            "Prepared".log()
        }
        
        values.forEach { value in 
            FLite.create(model: value) {
                "Created: \($0)".log()
            }
        }
        
        FLite.fetch(model: Todo.self) { qb in
            qb.all()
                .whenSuccess {
                    "Value: \($0)".log()
                    values = $0
                    semaphore.signal()
            }
        }
        
        semaphore.wait()
        XCTAssert(values.count > 0)
    }
    
    func testTodoList_big() {
        let semaphore = DispatchSemaphore(value: 0)
        var bigList: TodoList?
        
        FLite.storage = .memory
        
        FLite.manager.set(maxConnections: 10)
        
        FLite.manager.set(id: "Something Else")
        
        FLite.prepare(model: Todo.self) {
            "Prepared".log()
        }
        
        FLite.prepare(model: TodoList.self) {
            "TodoList Ready".log()
        }
        
        let list = TodoList(title: "First", items: (0 ..< 100_000).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 100_000))", strings: ["1", "two", "111"]) })
        
        FLite.create(model: list) { (value) in
            "Created: \(value)".log()
        }
        
        FLite.create(model: TodoList(title: "BIG", items: (0 ..< 1_000_000).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 1_000_000))", strings: []) })) {
            "Created: \($0)".log()
        }
        
        FLite.fetch(model: TodoList.self) { qb in
            qb.filter(\.title == "BIG")
                .first()
                .whenSuccess {
                    bigList = $0
                    semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        XCTAssertEqual(bigList?.items.count, 1_000_000)
    }
    
    static var allTests = [
        ("testExample", testExample),
        ("testTodoArray", testTodoArray)
    ]
}

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
        var values = (0 ..< 100).map { _ in Todo(title: "Todo #\(Int.random(in: 0 ... 10000))", strings: []) }
        
        FLite.storage = .memory

        FLite.manager.set(maxConnections: 15)

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

    static var allTests = [
        ("testExample", testExample),
        ("testTodoArray", testTodoArray)
    ]
}

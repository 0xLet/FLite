import XCTest
import FluentSQLite
@testable import FLite

final class FLiteTests: XCTestCase {
    func testExample() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = [Todo]()
        
        FLite.storage = .memory
        
        FLite.prepare(model: Todo.self) {
            print("Prepared")
        }
        
        FLite.create(model: Todo(title: "Hello World", strings: ["hello", "world"])) {
            print("Created: \($0)")
        }
        
        FLite.fetch(model: Todo.self)
            .whenSuccess { qb in
            qb.all()
                .whenSuccess {
                print($0)
                values = $0
                semaphore.signal()
            }
        }
        
        
        semaphore.wait()
        XCTAssert(values.count > 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}



/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String
    
    var someList: [String]

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, strings: [String]) {
        self.id = id
        self.title = title
        self.someList = strings
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

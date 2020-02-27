import XCTest
import FluentSQLite
@testable import FLite

final class FLiteTests: XCTestCase {
    func testExample() {
        let semaphore = DispatchSemaphore(value: 0)
        var values = [Todo]()
        
        FLite.storage = .memory
        
        FLite.prepare(model: Todo.self)
        
        FLite.create(model: Todo(title: "Hello World"))
        
        FLite.fetch(model: Todo.self) {
            values = $0
            semaphore.signal()
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

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

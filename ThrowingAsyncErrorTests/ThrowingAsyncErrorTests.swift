//
//  ThrowingAsyncErrorTests.swift
//  ThrowingAsyncErrorTests
//  

import XCTest
@testable import ThrowingAsyncError

class ThrowingAsyncErrorTests: XCTestCase {
    func testSyncError() {
        XCTAssertThrowsError(try Thrower("I WILL THROW"))
    }

    func testAsyncError() {
        let thrower = Thrower(test1: "I WILL THROW LATER")
        let futureErrorExpectation = thrower.newFutureErrorExpectation

        wait(for: [futureErrorExpectation], timeout: 5)
    }
}


/// Make a protocol to enforce testability
protocol FutureErrorTestable: class {
    var futureErrorExpectation: XCTestExpectation? { get set }
}

/// Encapsulate expectation generation for testing
extension FutureErrorTestable {
    var newFutureErrorExpectation: XCTestExpectation {
        let newExpectation = XCTestExpectation(description: "\(self) throws error")
        futureErrorExpectation = newExpectation
        return newExpectation
    }
}

class Thrower: FutureErrorTestable {
    init() { }

    /// Throw an error immediately
    convenience init(_ test: Any? = nil) throws {
        self.init()
        throw NowError.some
    }

    /// Throw an error after 1 second
    convenience init(test1: Any? = nil) {
        self.init()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (_) in
            if self != nil {
                self?.futureErrorExpectation?.fulfill()
            }
        }
    }

    /// You have to store an expectation to make asynchronous nested blocks fulfillable, because they can't throw
    var futureErrorExpectation: XCTestExpectation?
}

enum FutureError: Error {
    case some
}
enum NowError: Error {
    case some
}

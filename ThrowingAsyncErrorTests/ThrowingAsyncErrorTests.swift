//
//  ThrowingAsyncErrorTests.swift
//  ThrowingAsyncErrorTests
//
//  Created by Jasper Visser on 06/11/2019.
//  Copyright © 2019 Jasper Visser. All rights reserved.
//

import XCTest
@testable import ThrowingAsyncError

class ThrowingAsyncErrorTests: XCTestCase {

    func testSyncError() {
        XCTAssertThrowsError(ThrowingStruct())
    }
    
    func testAsyncErrorWithDeallocation() {
        let exp = expectation(description: "")
        var instance: ThrowingStructAfter2Seconds? = ThrowingStructAfter2Seconds()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            instance = nil
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testAsyncErrorWithoutDeallocation() {
        let exp = expectation(description: "")
        let instance = ThrowingStructAfter2Seconds()
        
        // How do I catch the error thrown by instance initializer?
        // I want to test to see if it crashed
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}

struct ThrowingStruct {
    init() {
        fatalError()
    }
}

class ThrowingStructAfter2Seconds {
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (_) in
            if self != nil {
                fatalError()
                
            }
        }
    }
}

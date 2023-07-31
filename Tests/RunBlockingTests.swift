//
//  RunBlockingTests.swift
//  
//
//  Created by Cesar Brazon on 17/7/23.
//

import XCTest
@testable import PolywrapClient

final class RunBlockingTests: XCTestCase {

    // Test the non-throwing version of runBlocking with a short async task
    func testRunBlockingShortTask() {
        let expectedValue = 5
        let result = runBlocking {
            try? await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
            return expectedValue
        }
        XCTAssertEqual(result, expectedValue)
    }

    // Test the non-throwing version of runBlocking with a long async task
    func testRunBlockingLongTask() {
        let expectedValue = 5
        let result = runBlocking {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 seconds
            return expectedValue
        }
        XCTAssertEqual(result, expectedValue)
    }
    
    // Test the throwing version of runBlocking when no error is thrown with a short async task
    func testRunBlockingNoThrowShortTask() {
        let expectedValue = 5
        do {
            let result = try runBlocking {
                try await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
                return expectedValue
            }
            XCTAssertEqual(result, expectedValue)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    // Test the throwing version of runBlocking when no error is thrown with a long async task
    func testRunBlockingNoThrowLongTask() {
        let expectedValue = 5
        do {
            let result = try runBlocking {
                try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second
                return expectedValue
            }
            XCTAssertEqual(result, expectedValue)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    // Test the throwing version of runBlocking when an error is thrown with a short async task
    func testRunBlockingThrowShortTask() {
        struct TestError: Error {}

        do {
            _ = try runBlocking {
                try await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
                throw TestError()
            }
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is TestError, "Unexpected error type: \(type(of: error))")
        }
    }
    
    // Test the throwing version of runBlocking when an error is thrown with a long async task
    func testRunBlockingThrowLongTask() {
        struct TestError: Error {}

        do {
            _ = try runBlocking {
                try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second
                throw TestError()
            }
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is TestError, "Unexpected error type: \(type(of: error))")
        }
    }
}

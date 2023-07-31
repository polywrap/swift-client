//
//  Enum.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient
import PolywrapClientNative

internal func getClientWithEnum() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "enum-type/implementations/rs")
    let wrapUri = try Uri("wrap/enum")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

enum EnumArg: Int, Encodable {
    case option1 = 0
    case option2 = 1
    case option3 = 2
    case unvalidOption = 5
}

struct MethodOneArgs: Encodable {
    let en: EnumArg
    let optEnum: EnumArg?
}

struct MethodTwoArgs: Encodable {
    let enumArray: [EnumArg]
    let optEnumArray: Int?
}

final class EnumTest: XCTestCase {

    func testMethodOneSuccess() throws {
        let (client, uri) = try getClientWithEnum()
        let args = MethodOneArgs(
            en: .option3,
            optEnum: .option1
        )
        let response: Int = try client.invoke(
            uri: uri,
            method: "method1",
            args: args
        )

        XCTAssertEqual(response, 2)
    }

    func testMethodOneFailure() throws {
        let (client, uri) = try getClientWithEnum()
        let args = MethodOneArgs(
            en: .unvalidOption,
            optEnum: nil
        )
        do {
            let _: Int = try client.invoke(
                uri: uri,
                method: "method1",
                args: args
            )
            XCTFail("Expected failure when providing an invalid enum value, but invocation succeeded.")
        } catch {
            if let error = error as? FfiError {
                switch error {
                case .InvokeError(_, _, let err):
                    XCTAssertTrue(err.contains("Invalid value for enum \'SanityEnum\': 5"), "Unexpected error: \(err)")
                default:
                    XCTFail("Unexpected error type: \(error)")
                }
            } else {
                XCTFail("Error is not of type FfiError: \(error)")
            }
        }
    }

    func testMethodTwoSuccess() throws {
        let (client, uri) = try getClientWithEnum()
        let args = MethodTwoArgs(
            enumArray: [.option1, .option1, .option3],
            optEnumArray: nil
        )
        let response: [Int] = try client.invoke(
            uri: uri,
            method: "method2",
            args: args
        )

        XCTAssertEqual(response, [0, 0, 2])
    }
}

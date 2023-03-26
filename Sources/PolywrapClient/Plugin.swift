import Foundation
import SwiftMsgpack
import PolywrapNativeClient

typealias WrapInvokeFunction = @convention(c) (
        UnsafeRawPointer,
        UnsafePointer<Int8>,
        UnsafePointer<Int8>,
        UnsafeMutableRawPointer
) -> UnsafePointer<Int8>

let invoke_plugin: WrapInvokeFunction = { pluginRawPtr, methodName, params, invoker in
    let methodNameLength = strlen(methodName)
    let methodNameBuffer = UnsafeBufferPointer(
            start: methodName.withMemoryRebound(to: UInt8.self, capacity: methodNameLength) { $0 },
            count: methodNameLength
    )
    let methodName = String(decoding: methodNameBuffer, as: UTF8.self)

    let paramsLength = strlen(params)
    let paramsBuffer = UnsafeBufferPointer(
            start: params.withMemoryRebound(to: UInt8.self, capacity: paramsLength) { $0 },
            count: paramsLength
    )
    let params = String(decoding: paramsBuffer, as: UTF8.self)
    let pluginPtr = Unmanaged<Plugin>.fromOpaque(pluginRawPtr)
    let plugin = pluginPtr.takeUnretainedValue()

    let entry = plugin.methodsMap[methodName]!

    guard let paramsJsonData = params.data(using: .utf8) else {
        fatalError("Failed to convert jsonString to Data.")
    }

    let invokeResult = (entry)(paramsJsonData)


    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // Optional, for better readability
    let jsonResultData = try! encoder.encode(invokeResult)
    let jsonResultString = String(data: jsonResultData, encoding: .utf8)!

    let utf8CString = jsonResultString.utf8CString
    let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: utf8CString.count)
    let bufferPointer = UnsafeMutableBufferPointer(start: buffer, count: utf8CString.count)
    _ = bufferPointer.initialize(from: utf8CString)

    return UnsafePointer(buffer)
}

class Plugin {
    public var methodsMap: [String: (_ args: Data) -> Codable] = [:]
}
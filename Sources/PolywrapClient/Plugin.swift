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
    let methodNameString = String(cString: methodName)
    let paramsString = String(cString: params)

    let pluginPtr = Unmanaged<Plugin>.fromOpaque(pluginRawPtr)
    let plugin = pluginPtr.takeUnretainedValue()

    guard let entry = plugin.methodsMap[methodNameString] else {
        fatalError("Method '\(methodNameString)' not found in methodsMap.")
    }

    guard let paramsJsonData = paramsString.data(using: .utf8) else {
        fatalError("Failed to convert paramsString to Data.")
    }

    let invokeResult = entry(paramsJsonData)

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
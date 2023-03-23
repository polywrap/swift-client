import Foundation
import Cpolywrap_ffi_c
import SwiftMsgpack

typealias WrapInvokeFunction = @convention(c) (
        _ pluginPtr: UnsafeMutableRawPointer,
        _ methodName: UnsafePointer<Int8>,
        _ paramsBuffer: UnsafePointer<UInt8>?,
        _ paramsLen: Int,
        _ invoker: UnsafeRawPointer?
) -> UnsafePointer<Buffer>

let invoke_plugin: WrapInvokeFunction = { pluginRawPtr, methodName, paramsBuffer, paramsLen, invoker in
    let bufferPointer = UnsafeBufferPointer(start: paramsBuffer, count: paramsLen)
    let encodedParams = Array(bufferPointer)

    let methodNameLength = strlen(methodName)
    let methodNameBuffer = UnsafeBufferPointer(
            start: methodName.withMemoryRebound(to: UInt8.self, capacity: methodNameLength) { $0 },
            count: methodNameLength
    )
    let methodName = String(decoding: methodNameBuffer, as: UTF8.self)
    let pluginPtr = pluginRawPtr.assumingMemoryBound(to: Plugin.self)
    let plugin = pluginPtr.pointee

    guard let entry = plugin.methodsMap[methodName] else {
        let emptyBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
        return create_buffer(emptyBufferPtr, 0)
    }

    let decoder = MsgPackDecoder()
    let decodedArgs = try! decoder.decode(entry.type, from: Data(encodedParams))
    let invokeResult = (entry.method)(decodedArgs)

    let encoder = MsgPackEncoder()
    let encodedResult = try! encoder.encode(invokeResult)
    let resultData = try! encoder.encode(invokeResult)
    var resultBytes = [UInt8](repeating: 0, count: resultData.count)
    let resultBytesCount = resultBytes.count

    resultData.withUnsafeBytes { bufferPointer in
        let buffer = UnsafeBufferPointer<UInt8>(start: bufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self), count: bufferPointer.count)
        resultBytes = Array(buffer)
    }

    return resultBytes.withUnsafeMutableBufferPointer { bufferPointer in
        create_buffer(bufferPointer.baseAddress, UInt(resultBytesCount))
    }
}

class Plugin {
    var methodsMap: [String: (method: (_ args: Decodable) -> Codable, type: Decodable.Type)] = [:]

    init() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let method = child.value as? (Decodable) -> Any {
                guard let name = child.label else {
                    fatalError("Method label not found")
                }
                let argumentType = methodArgumentType(for: child)

                methodsMap[name] = ({ input in
                    guard let codableInput = input as? Decodable else {
                        fatalError("Invalid input type")
                    }
                    let result = method(codableInput)
                    if let codableResult = result as? Codable {
                        return codableResult
                    }
                    fatalError("Invalid method return type")
                }, argumentType)

                print("Method \(name) has argument type \(argumentType)")
            }
        }
    }

    private func methodArgumentType(for child: Mirror.Child) -> Decodable.Type {
        guard let methodMirror = Mirror(reflecting: child.value) as? Mirror,
              methodMirror.displayStyle == .tuple,
              let argumentType = methodMirror.children.first?.value as? Decodable.Type
        else {
            fatalError("Invalid method argument type")
        }
        return argumentType
    }
}
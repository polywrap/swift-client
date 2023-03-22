import Foundation
import Cpolywrap_ffi_c
import SwiftMsgpack

typealias WrapInvokeFunction = @convention(c) (
        _ method_name: UnsafePointer<Int8>,
        _ params_buffer: UnsafePointer<UInt8>?,
        _ params_len: Int,
        _ invoker: UnsafeRawPointer?
) -> Buffer

typealias MethodsMap = [String: (method: (_ args: Decodable) -> Codable, type: Decodable.Type)]

struct PluginModule {
    let _wrap_invoke: WrapInvokeFunction

    init(methods_map: MethodsMap) {
        _wrap_invoke = { method_name, params_buffer, params_len, invoker in
            let bufferPointer = UnsafeBufferPointer(start: params_buffer, count: params_len)
            let encodedParams = Array(bufferPointer)

            let methodNameLength = strlen(method_name)
            let methodNameBuffer = UnsafeBufferPointer(
                    start: method_name.withMemoryRebound(to: UInt8.self, capacity: methodNameLength) { $0 },
                    count: methodNameLength
            )
            let methodName = String(decoding: methodNameBuffer, as: UTF8.self)

            if let entry = methods_map[methodName] {
                let decoder = MsgPackDecoder()
                let decodedArgs = try! decoder.decode(entry.type, from: Data(encodedParams))
                let invokeResult = (entry.method)(decodedArgs)

                let encoder = MsgPackEncoder()
                let encodedResult = try! encoder.encode(invokeResult);

                encodedResult.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> Void in
                    let bufferPointer = bytes.bindMemory(to: UInt8.self)
                    let bufferLength = bytes.count

                    return ArrayBuffer(data: bufferPointer.baseAddress, len: UInt(bufferLength))
                }
            }
        }

    }
}

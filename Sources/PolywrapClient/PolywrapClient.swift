import PolywrapNativeClient
import Foundation

public struct PolywrapClient {
    private let clientPtr: UnsafeMutableRawPointer

    init(clientConfigBuilder: ConfigBuilder) {
        clientPtr = clientConfigBuilder.build()
    }

    func invoke<T: Codable>(uri: Uri, method: String, args: T?, env: String?) -> String {
        let uriPtr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        let methodPtr = method.cString(using: .utf8).unsafelyUnwrapped

        var optArgs: [CChar]? = nil;

        if let args = args {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional, for better readability
            let jsonData = try! encoder.encode(args)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            optArgs = jsonString.cString(using: .utf8).unsafelyUnwrapped
        }

        let env = env?.cString(using: .utf8).unsafelyUnwrapped

        let result = invokeRawFunc(clientPtr, uriPtr, methodPtr, optArgs, env);

        let resultLength = strlen(result)
        let resultBuffer = UnsafeBufferPointer(
                start: result.withMemoryRebound(to: UInt8.self, capacity: resultLength) { $0 },
                count: resultLength
        )

        return String(decoding: resultBuffer, as: UTF8.self)
    }
}

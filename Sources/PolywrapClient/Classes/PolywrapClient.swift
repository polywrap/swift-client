import Foundation
import PolywrapNativeClient

public struct PolywrapClient {
    private let clientPtr: UnsafeMutableRawPointer

    public init(clientConfigBuilder: ConfigBuilder) {
        clientPtr = clientConfigBuilder.build()
    }

    public func invoke<T: Codable>(uri: Uri, method: String, args: T?, env: String?) -> String {
        print("CLIENT Current thread \(Thread.current)")
        guard let uriPtr = uri.uri.cString(using: .utf8),
              let methodPtr = method.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        var optArgs: [CChar]? = nil

        if let args = args {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional, for better readability
            let jsonData = try! encoder.encode(args)
            guard let jsonString = String(data: jsonData, encoding: .utf8),
                  let jsonStringPtr = jsonString.cString(using: .utf8) else {
                fatalError("Failed to convert args to JSON string.")
            }
            optArgs = jsonStringPtr
        }

        let envPtr = env?.cString(using: .utf8)

        let result = invoke_raw(clientPtr, uriPtr, methodPtr, optArgs, envPtr)
        print("CLIENT AFTER INV Current thread \(Thread.current)")
        let resultString = String(cString: result)
        return resultString
    }
}

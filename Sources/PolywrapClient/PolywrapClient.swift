import PolywrapNativeClient
import Foundation

public struct PolywrapClient {
    private let clientPtr: UnsafeMutableRawPointer

    init(clientConfigBuilder: ConfigBuilder) {
        clientPtr = clientConfigBuilder.build()
    }

    func invoke<T: Codable>(uri: Uri, method: String, args: T?, env: String?) -> String {
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

        let result = invokeRawFunc(clientPtr, uriPtr, methodPtr, optArgs, envPtr)
        let resultString = String(cString: result)
        return resultString
    }
}
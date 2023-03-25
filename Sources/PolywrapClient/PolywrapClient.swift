import PolywrapNativeClient

public struct PolywrapClient {
    private let clientPtr: UnsafeMutableRawPointer

    init(clientConfigBuilder: ConfigBuilder) {
        clientPtr = clientConfigBuilder.build()
    }

    func invoke(uri: Uri, method: String, args: String?, env: String?) -> Array<UInt8> {
        let uriPtr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        let methodPtr = method.cString(using: .utf8).unsafelyUnwrapped

        var optArgs: UnsafePointer<Buffer>? = nil;

        if let args = args {
            optArgs = encodeFunc(args.cString(using: .utf8).unsafelyUnwrapped)
        }

        let env = env?.cString(using: .utf8).unsafelyUnwrapped

        let result = invokeRawFunc(clientPtr, uriPtr, methodPtr, optArgs!, env!);

        let bufferPointer = UnsafeBufferPointer(start: result.pointee.data, count: Int(result.pointee.len))
        return Array(bufferPointer)
    }
}

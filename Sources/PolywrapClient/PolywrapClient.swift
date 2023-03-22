import Cpolywrap_ffi_c

public struct PolywrapClient {
    private let clientPtr: OpaquePointer

    init(clientConfigBuilder: ConfigBuilder) {
        clientPtr = clientConfigBuilder.build()
    }

    func invoke(uri: Uri, method: String, args: String?, env: String?) -> Array<UInt8> {
        let uriPtr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        let methodPtr = method.cString(using: .utf8).unsafelyUnwrapped

        var optArgs: UnsafePointer<Buffer>? = nil;

        if let args = args {
            optArgs = encode(args.cString(using: .utf8).unsafelyUnwrapped)
        }

        let env = env?.cString(using: .utf8).unsafelyUnwrapped

        let result = invoke_raw(clientPtr, uriPtr, methodPtr, optArgs, env)!;

        let bufferPointer = UnsafeBufferPointer(start: result.pointee.data, count: Int(result.pointee.len))
        return Array(bufferPointer)
    }
}

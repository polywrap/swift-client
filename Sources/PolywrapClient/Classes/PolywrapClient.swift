import PolywrapClientNative


public class PolywrapClient: FfiClient {
    public func invoke<T: Codable, R: Codable>(
        uri: Uri,
        method: String,
        args: T,
        env: T
    ) throws -> R {
        let encoded_args = try! encode(value: args)
        let encoded_env = try! encode(value: env)
        let result = try self.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encoded_args,
            env: encoded_env,
            resolutionContext: nil
        )
        
        return try! decode(value: result)
    }
}

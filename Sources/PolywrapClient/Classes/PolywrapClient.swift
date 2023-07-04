import PolywrapClientNative


public class PolywrapClient {
    public let ffi: FfiClient
    public init(client: FfiClient) {
        self.ffi = client
    }
    
    public func invoke<R: Decodable>(
        uri: Uri,
        method: String
    ) throws -> R {
        let encoded_args: [UInt8]? = nil
        let encoded_env: [UInt8]? = nil
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encoded_args,
            env: encoded_env,
            resolutionContext: nil
        )
        
        return try decode(value: result)
    }
    
    public func invoke<T: Encodable, R: Decodable>(
        uri: Uri,
        method: String,
        args: T?,
        env: T?
    ) throws -> R {
        let encoded_args = try encode(value: args)
        let encoded_env = try encode(value: env)
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encoded_args,
            env: encoded_env,
            resolutionContext: nil
        )
        
        return try decode(value: result)
    }
    
    public func getEnvByUri<T: Decodable>(_ uri: Uri) throws -> T? {
        guard let env = self.ffi.getEnvByUri(uri: uri.ffi) else {
            return nil
        }
        return try decode(value: env)
    }
    
    public func getImplementations(_ uri: Uri) throws -> [Uri] {
        let implementations = try self.ffi.getImplementations(uri: uri.ffi)
        return try implementations.compactMap { implementationUri -> Uri in
            return try Uri(ffi: implementationUri)
        }
    }
}

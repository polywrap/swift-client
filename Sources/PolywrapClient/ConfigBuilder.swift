import Foundation
import PolywrapNativeClient

class ConfigBuilder {
    let builderPtr: UnsafeMutableRawPointer

    init() {
        builderPtr = newBuilderConfigFunc()
    }

    //func addRedirect(from: Uri, to: Uri) {
    //    guard let toPtr = to.uri.cString(using: .utf8),
    //          let fromPtr = from.uri.cString(using: .utf8) else {
    //        fatalError("Failed to convert URI strings to C strings.")
     //   }

    //    addEnvFunc(builderPtr, uriPtr, envPtr)
    //}

    func addEnv(uri: Uri, env: Data) {
        guard let envString = String(data: env, encoding: .utf8),
              let envPtr = envString.cString(using: .utf8),
              let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        addEnvFunc(builderPtr, uriPtr, envPtr)
    }

    func removeEnv(uri: Uri) {
        guard let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert uri string to C string.")
        }

        removeEnvFunc(builderPtr, uriPtr)
    }

    func setEnv(uri: Uri, env: Data) {
        guard let envString = String(data: env, encoding: .utf8),
              let envPtr = envString.cString(using: .utf8),
              let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        setEnvFunc(builderPtr, uriPtr, envPtr)
    }

    func addPlugin<T: Plugin>(uri: Uri, plugin: T) {
        let pluginPtr = Unmanaged.passRetained(plugin).toOpaque()

        guard let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert uri string to C string.")
        }

        let invokePluginFnPtr = unsafeBitCast(invoke_plugin, to: WrapInvokeFunction.self)

        addPluginWrapperFunc(builderPtr, uriPtr, pluginPtr, invokePluginFnPtr)
    }

    func build() -> UnsafeMutableRawPointer {
        createClientFunc(builderPtr)
    }
}
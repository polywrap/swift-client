import Foundation
import PolywrapNativeClient

public class ConfigBuilder {
    let builderPtr: UnsafeMutableRawPointer

    public init() {
        builderPtr = new_builder_config()
    }

    func addRedirect(from: Uri, to: Uri) {
        guard let toPtr = to.uri.cString(using: .utf8),
              let fromPtr = from.uri.cString(using: .utf8) else {
            fatalError("Failed to convert URI strings to C strings.")
        }

        addRedirectFunc(builderPtr, fromPtr, toPtr)
    }

    func removeRedirect(from: Uri) {
        guard let fromPtr = from.uri.cString(using: .utf8) else {
            fatalError("Failed to convert URI strings to C strings.")
        }

        removeRedirectFunc(builderPtr, fromPtr)
    }

    func addInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
        guard let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8),
              let implementationUriPtr = implementationUri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        addInterfaceImplementationFunc(builderPtr, interfaceUriPtr, implementationUriPtr)
    }

    func removeInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
        guard let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8),
              let implementationUriPtr = implementationUri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        removeInterfaceImplementationFunc(builderPtr, interfaceUriPtr, implementationUriPtr)
    }

    public func addEnv(uri: Uri, env: Data) {
        guard let envString = String(data: env, encoding: .utf8),
              let envPtr = envString.cString(using: .utf8),
              let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        add_env(builderPtr, uriPtr, envPtr)
    }

    public func removeEnv(uri: Uri) {
        guard let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert uri string to C string.")
        }

        remove_env(builderPtr, uriPtr)
    }

    public func setEnv(uri: Uri, env: Data) {
        guard let envString = String(data: env, encoding: .utf8),
              let envPtr = envString.cString(using: .utf8),
              let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert strings to C strings.")
        }

        set_env(builderPtr, uriPtr, envPtr)
    }

    public func addPlugin<T: Plugin>(uri: Uri, plugin: T) {
        let pluginPtr = Unmanaged.passRetained(plugin).toOpaque()

        guard let uriPtr = uri.uri.cString(using: .utf8) else {
            fatalError("Failed to convert uri string to C string.")
        }

        let invokePluginFnPtr = unsafeBitCast(invoke_plugin, to: WrapInvokeFunction.self)

        add_plugin_wrapper(builderPtr, uriPtr, pluginPtr, invokePluginFnPtr)
    }

    public func build() -> UnsafeMutableRawPointer {
        create_client(builderPtr)
    }
}

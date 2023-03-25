import Foundation
import PolywrapNativeClient

class ConfigBuilder {
    let builderPtr: UnsafeMutableRawPointer;

    init() {
        builderPtr = newBuilderConfigFunc()
    }

    func addEnv(uri: Uri, env: Data) {
        let envString = String(data: env, encoding: .utf8);
        let envPtr = envString?.cString(using: .utf8).unsafelyUnwrapped
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        addEnvFunc(builderPtr, uri_ptr, envPtr!)
    }

    func removeEnv(uri: Uri) {
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        removeEnvFunc(builderPtr, uri_ptr)
    }

    func setEnv(uri: Uri, env: Data) {
        let envString = String(data: env, encoding: .utf8);
        let envPtr = envString?.cString(using: .utf8).unsafelyUnwrapped
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        setEnvFunc(builderPtr, uri_ptr, envPtr!)
    }

//    func addInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
//        let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8).unsafelyUnwrapped
//        let implementationUriPtr = implementationUri.uri.cString(using: .utf8).unsafelyUnwrapped
//
//        add_interface_implementation(builderPtr, interfaceUriPtr, implementationUriPtr)
//    }
//
//    func removeInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
//        let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8).unsafelyUnwrapped
//        let implementationUriPtr = implementationUri.uri.cString(using: .utf8).unsafelyUnwrapped
//
//        remove_interface_implementation(builderPtr, interfaceUriPtr, implementationUriPtr)
//    }

    func addPlugin<T: Plugin>(uri: Uri, plugin: T) {
        let pluginPtr = Unmanaged.passRetained(plugin).toOpaque()
        let uriPtr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        let invokePluginFnPtr = unsafeBitCast(invoke_plugin, to: WrapInvokeFunction.self)

        addPluginWrapperFunc(builderPtr, uriPtr, pluginPtr, invokePluginFnPtr)
    }

    func build() -> UnsafeMutableRawPointer {
       createClientFunc(builderPtr)
    }
}
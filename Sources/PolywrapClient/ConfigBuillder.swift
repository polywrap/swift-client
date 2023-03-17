import Foundation
import Cpolywrap_ffi_c

class ConfigBuilder {
    let builderPtr: OpaquePointer;

    init() {
        builderPtr = OpaquePointer(new_builder_config())
    }

    func addEnv(uri: Uri, env: Data) {
        let envString = String(data: env, encoding: .utf8);
        let envPtr = envString?.cString(using: .utf8).unsafelyUnwrapped
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        add_env(builderPtr, uri_ptr, envPtr)
    }

    func removeEnv(uri: Uri) {
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        remove_env(builderPtr, uri_ptr)
    }

    func setEnv(uri: Uri, env: Data) {
        let envString = String(data: env, encoding: .utf8);
        let envPtr = envString?.cString(using: .utf8).unsafelyUnwrapped
        let uri_ptr = uri.uri.cString(using: .utf8).unsafelyUnwrapped
        set_env(builderPtr, uri_ptr, envPtr)
    }

    func addInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
        let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8).unsafelyUnwrapped
        let implementationUriPtr = implementationUri.uri.cString(using: .utf8).unsafelyUnwrapped

        add_interface_implementation(builderPtr, interfaceUriPtr, implementationUriPtr)
    }

    func removeInterfaceImplementation(interfaceUri: Uri, implementationUri: Uri) {
        let interfaceUriPtr = interfaceUri.uri.cString(using: .utf8).unsafelyUnwrapped
        let implementationUriPtr = implementationUri.uri.cString(using: .utf8).unsafelyUnwrapped

        remove_interface_implementation(builderPtr, interfaceUriPtr, implementationUriPtr)
    }

    func addWrapper()
}
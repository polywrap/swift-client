import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

class NativeLibraryLoader {
    static func loadLibrary() -> UnsafeMutableRawPointer? {
//        let fileManager = FileManager.default
//        guard let currentWorkingDirectory = try? fileManager.currentDirectoryPath as NSString else {
//            fatalError("Could not get the current working directory")
//        }
//
//        let relativePath = "./libpolywrapnativeclient.so"
//        let absolutePath = currentWorkingDirectory.appendingPathComponent(relativePath)
//
//        print(absolutePath)

        let NativeClientLib = dlopen("/home/namesty/Documents/PolywrapClient/Sources/PolywrapClient/libpolywrapnativeclient.so", RTLD_NOW)!
        return NativeClientLib
    }
}

let nativeClientLib = NativeLibraryLoader.loadLibrary()

struct Buffer {
    var data: UnsafeMutablePointer<UInt8>
    var len: UInt
}

typealias NewBuilderConfigFunc = @convention(c) () -> UnsafeMutableRawPointer
let newBuilderConfigSymbol = dlsym(nativeClientLib, "new_builder_config")
let newBuilderConfigFunc = unsafeBitCast(newBuilderConfigSymbol, to: NewBuilderConfigFunc.self)

typealias AddEnvFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>) -> Void
let addEnvSymbol = dlsym(nativeClientLib, "add_env")
let addEnvFunc = unsafeBitCast(addEnvSymbol, to: AddEnvFunc.self)

typealias RemoveEnvFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>) -> Void
let removeEnvSymbol = dlsym(nativeClientLib, "remove_env")
let removeEnvFunc = unsafeBitCast(removeEnvSymbol, to: RemoveEnvFunc.self)

typealias SetEnvFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>) -> Void
let setEnvSymbol = dlsym(nativeClientLib, "set_env")
let setEnvFunc = unsafeBitCast(setEnvSymbol, to: SetEnvFunc.self)

typealias AddPluginWrapperFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafeRawPointer, WrapInvokeFunction) -> Void
let addPluginWrapperSymbol = dlsym(nativeClientLib, "add_plugin_wrapper")
let addPluginWrapperFunc = unsafeBitCast(addPluginWrapperSymbol, to: AddPluginWrapperFunc.self)

typealias BuildClientFunc = @convention(c) (UnsafeMutableRawPointer) -> UnsafeRawPointer
let buildClientSymbol = dlsym(nativeClientLib, "build_client")
let buildClientFunc = unsafeBitCast(buildClientSymbol, to: BuildClientFunc.self)

typealias CreateStaticResolverFunc = @convention(c) (UnsafePointer<Void>, UInt) -> UnsafeMutableRawPointer
let createStaticResolverSymbol = dlsym(nativeClientLib, "create_static_resolver")
let createStaticResolverFunc = unsafeBitCast(createStaticResolverSymbol, to: CreateStaticResolverFunc.self)

typealias CreateExtendableResolverFunc = @convention(c) () -> UnsafeMutableRawPointer
let createExtendableResolverSymbol = dlsym(nativeClientLib, "create_extendable_resolver")
let createExtendableResolverFunc = unsafeBitCast(createExtendableResolverSymbol, to: CreateExtendableResolverFunc.self)

typealias CreateClientFunc = @convention(c) (UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
let createClientSymbol = dlsym(nativeClientLib, "create_client")
let createClientFunc = unsafeBitCast(createClientSymbol, to: CreateClientFunc.self)

typealias AddRedirectResolverFunc = @convention(c) (UnsafeMutableRawPointer, UnsafeRawPointer) -> Void
let addRedirectResolverSymbol = dlsym(nativeClientLib, "add_redirect_resolver")
let addRedirectResolverFunc = unsafeBitCast(addRedirectResolverSymbol, to: AddRedirectResolverFunc.self)

typealias CreateBufferFunc = @convention(c) (UnsafeMutablePointer<UInt8>, UInt) -> UnsafeRawPointer
let createBufferSymbol = dlsym(nativeClientLib, "create_buffer")
let createBufferFunc = unsafeBitCast(createBufferSymbol, to: CreateBufferFunc.self)

typealias InvokeRawFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>, UnsafePointer<Int8>?, UnsafePointer<Int8>?) -> UnsafePointer<Int8>
let invokeRawSymbol = dlsym(nativeClientLib, "invoke_raw")
let invokeRawFunc = unsafeBitCast(invokeRawSymbol, to: InvokeRawFunc.self)

typealias EncodeFunc = @convention(c) (UnsafePointer<Int8>) -> UnsafeRawPointer
let encodeSymbol = dlsym(nativeClientLib, "encode")
let encodeFunc = unsafeBitCast(encodeSymbol, to: EncodeFunc.self)

typealias AddRedirectFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>) -> Void
let addRedirectSymbol = dlsym(nativeClientLib, "add_redirect")
let addRedirectFunc = unsafeBitCast(addRedirectSymbol, to: AddRedirectFunc.self)

typealias RemoveRedirectFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>) -> Void
let removeRedirectSymbol = dlsym(nativeClientLib, "remove_redirect")
let removeRedirectFunc = unsafeBitCast(removeRedirectSymbol, to: RemoveRedirectFunc.self)

typealias AddInterfaceImplementationFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>) -> Void
let addInterfaceImplementationSymbol = dlsym(nativeClientLib, "add_interface_implementation")
let addInterfaceImplementationFunc = unsafeBitCast(addInterfaceImplementationSymbol, to: AddInterfaceImplementationFunc.self)

typealias RemoveInterfaceImplementationFunc = @convention(c) (UnsafeMutableRawPointer, UnsafePointer<Int8>, UnsafePointer<Int8>) -> Void
let removeInterfaceImplementationSymbol = dlsym(nativeClientLib, "remove_interface_implementation")
let removeInterfaceImplementationFunc = unsafeBitCast(removeInterfaceImplementationSymbol, to: RemoveInterfaceImplementationFunc.self)
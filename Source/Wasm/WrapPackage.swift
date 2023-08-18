//
//  WrapPackage.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import PolywrapClientNative

/// An enumeration of errors that can be thrown when working with a `WasmPackage`.
public enum WasmPackageError: Error {
    /// Thrown when no `Reader` is available to read the module.
    case readerMissing
    /// Thrown when there is an error loading the module.
    case loadModuleError
    /// Thrown when the `module` is unexpectedly `nil`.
    case unexpectedNilModule
}

/// Represents a WRAP package.
public class WasmPackage: IffiWrapPackage {
    /// The `Reader` used to read the module.
    public let reader: Reader?
    /// The module as an array of bytes (`UInt8`).
    public var module: [UInt8]?

    /// Creates a new instance of `WasmPackage`.
    ///
    /// - Parameters:
    ///   - reader: The `Reader` used to read the module. This can be `nil`.
    ///   - module: The module as an array of bytes (`UInt8`). This can be `nil`.
    public init(reader: Reader?, module: [UInt8]?) {
        self.reader = reader
        self.module = module
    }

    /// Fetches the module as an array of bytes (`UInt8`).
    ///
    /// If the module is not yet loaded, it attempts to read it from the provided `Reader`.
    /// Throws an error if no `Reader` is available, or if the module cannot be loaded.
    ///
    /// - Returns: The module as an array of bytes (`UInt8`).
    /// - Throws: `WasmPackageError` if there are issues getting the module.
    public func getModule() throws -> [UInt8] {
        if let module = self.module {
            return module
        }

        guard let reader = self.reader else {
            throw WasmPackageError.readerMissing
        }

        do {
            self.module = try reader.readFile(nil)
        } catch {
            throw WasmPackageError.loadModuleError
        }

        if let module = self.module {
            return module
        }

        // This should never happen.
        // But if it does, throw a custom error to handle this unexpected state.
        throw WasmPackageError.unexpectedNilModule
    }

    /// Creates a new `WasmWrapper` for the package's module.
    ///
    /// If the module has not been loaded yet, it attempts to load it.
    ///
    /// - Returns: A `WasmWrapper` for the module.
    /// - Throws: `WasmPackageError` if there are issues creating the wrapper.
    public func createWrapper() throws -> IffiWrapper {
        if let module = self.module {
            return try WasmWrapper(module: module)
        } else {
            let module = try self.getModule()
            return try WasmWrapper(module: module)
        }
    }
}

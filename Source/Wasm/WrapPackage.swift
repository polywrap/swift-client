//
//  WrapPackage.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import PolywrapClientNativeLib

public enum WasmPackageError: Error {
    case readerMissing
    case loadModuleError
    case unexpectedNilModule
}

public class WasmPackage: FfiWrapPackage {
    public let reader: Reader?
    public var module: [UInt8]?

    public init(reader: Reader?, module: [UInt8]?) {
        self.reader = reader
        self.module = module
    }

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

    public func createWrapper() throws -> FfiWrapper {
        return WasmWrapper(module: self.module)
    }
}

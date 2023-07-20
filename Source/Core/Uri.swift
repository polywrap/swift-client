//
//  Uri.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation
import PolywrapClientNativeLib

/// An enum type for defining error cases related to `Uri` operations.
public enum UriError: Error, Equatable {
    case parseError(String)  // An error case for URI parsing failures.
}

/// `Uri` is a class used to manage URIs within the context of the Polywrap client.
public class Uri {
    public let ffi: FfiUri  // An instance of `FfiUri` class provided by `PolywrapClientNativeLib`.

    /// Initializer accepting a URI string. It attempts to create an `FfiUri` instance from the string.
    /// If the operation fails, throws a `UriError.parseError`.
    ///
    /// - Parameter uri: A string representing the URI.
    public init(_ uri: String) throws {
        do {
            self.ffi = try ffiUriFromString(uri: uri)
        } catch {
            throw UriError.parseError("Invalid URI Received: \(uri)")
        }
    }

    /// Initializer accepting an instance of `FfiUri`.
    /// It directly assigns the passed `FfiUri` instance to the `ffi` property.
    ///
    /// - Parameter ffi: An instance of `FfiUri` type.
    public init(ffi: FfiUri) throws {
        self.ffi = ffi
    }

    /// Initializer accepting an authority string, a path string, and a URI string.
    /// It creates an `FfiUri` instance using these components.
    ///
    /// - Parameters:
    ///   - authority: A string representing the authority part of the URI.
    ///   - path: A string representing the path part of the URI.
    ///   - uri: A string representing the full URI.
    public init(_ authority: String, _ path: String, uri: String) {
        self.ffi = FfiUri(authority: authority, path: path, uri: uri)
    }
}

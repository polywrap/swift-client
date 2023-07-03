//
//  Utils.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation

public enum ReaderError: Error {
    case fileNotFound
    case unableToLoadFile(Error)
}

public class ResourceReader: Reader {
    let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    public func readFile(_ path: String?) throws -> [UInt8] {
        guard let url = bundle.url(forResource: "wrap", withExtension: "wasm", subdirectory: path) else {
            throw ReaderError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            var byteArray = [UInt8](repeating: 0, count: data.count)
            data.copyBytes(to: &byteArray, count: data.count)
            return byteArray
        } catch {
            throw ReaderError.unableToLoadFile(error)
        }
    }
}

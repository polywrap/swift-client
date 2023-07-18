import Foundation

public protocol Reader {
    func readFile(_ path: String?) throws -> [UInt8]
}

public enum ReaderError: Error {
    case fileNotFound
    case unableToLoadFile(Error)
}

public class ResourceReader: Reader {
    let bundle: Bundle
    let path: String?

    public init(bundle: Bundle) {
        self.bundle = bundle
        self.path = nil
    }

    public init(bundle: Bundle, path: String) {
        self.bundle = bundle
        self.path = path
    }

    public func readFile(_ path: String?) throws -> [UInt8] {
        guard let url = bundle.url(forResource: "wrap", withExtension: "wasm", subdirectory: path ?? self.path) else {
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

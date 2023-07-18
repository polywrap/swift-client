import Foundation

/// `Reader` is a protocol defining the signature of the readFile method.
public protocol Reader {
    /// Method to read a file and return it as a byte array. 
    ///
    /// - Parameter path: The optional path to the file.
    /// - Returns: A byte array representing the file's content.
    /// - Throws: If an error occurs when reading the file.
    func readFile(_ path: String?) throws -> [UInt8]
}

/// `ReaderError` defines possible errors that can occur while reading files.
public enum ReaderError: Error {
    case fileNotFound  // The file could not be found at the provided path.
    case unableToLoadFile(Error)  // There was an error when attempting to load the file.
}

/// `ResourceReader` is a class that implements the `Reader` protocol.
/// It reads files from a provided bundle and optional path.
public class ResourceReader: Reader {
    let bundle: Bundle  // The bundle from which files are read.
    let path: String?  // The optional path in the bundle where the files are located.

    /// Creates a `ResourceReader` with the given `Bundle` and an optional path.
    ///
    /// - Parameter bundle: The `Bundle` where the files are located.
    public init(bundle: Bundle) {
        self.bundle = bundle
        self.path = nil
    }

    /// Creates a `ResourceReader` with the given `Bundle` and a specified path.
    ///
    /// - Parameters:
    ///   - bundle: The `Bundle` where the files are located.
    ///   - path: The path in the `Bundle` where the files are located.
    public init(bundle: Bundle, path: String) {
        self.bundle = bundle
        self.path = path
    }

    /// Reads the file at the given path (or the instance's path if no path is provided)
    /// and returns the contents as a byte array. The file is expected to be a `.wasm` file.
    ///
    /// - Parameter path: The path to the file. If `nil`, the instance's `path` property is used.
    /// - Returns: A byte array of the file's contents.
    /// - Throws: `ReaderError.fileNotFound` if the file could not be found.
    ///           `ReaderError.unableToLoadFile` if there was an error when trying to read the file.
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

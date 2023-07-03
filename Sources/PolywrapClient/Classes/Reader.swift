import Foundation

public protocol Reader {
    func readFile(_ path: String?) throws -> [UInt8]
}

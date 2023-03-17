import Foundation

struct Uri: Equatable, CustomStringConvertible {
    let authority: String
    let path: String
    let uri: String

    init?(_ uri: String) {
        guard let parsedUri = Uri.fromString(uri: uri) else {
            return nil
        }
        self = parsedUri
    }

    init(authority: String, path: String, uri: String) {
        self.authority = authority
        self.path = path
        self.uri = uri
    }

    private static func fromString(uri: String) -> Uri? {
        var processed = uri

        while processed.hasPrefix("/") {
            processed = String(processed.dropFirst())
        }

        if !processed.hasPrefix("wrap://") {
            processed = "wrap://" + processed
        }

        let pattern = "wrap://([a-z][a-z0-9-_]+)/(.*)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        guard let match = regex?.firstMatch(in: processed, options: [], range: NSRange(location: 0, length: processed.utf16.count)) else {
            return nil
        }

        let authorityRange = Range(match.range(at: 1), in: processed)!
        let pathRange = Range(match.range(at: 2), in: processed)!

        return Uri(
                authority: String(processed[authorityRange]),
                path: String(processed[pathRange]),
                uri: processed
        )
    }

    var description: String {
        uri
    }
}
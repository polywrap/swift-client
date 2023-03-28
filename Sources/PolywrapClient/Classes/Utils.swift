import Foundation

func encodeToJSON<T: Codable>(_ value: T) -> [CChar]? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // Optional, for better readability
    guard let jsonData = try? encoder.encode(value),
          let jsonString = String(data: jsonData, encoding: .utf8),
          let jsonStringPtr = jsonString.cString(using: .utf8) else {
        return nil
    }
    return jsonStringPtr
}

func decodeFromJSON<T: Codable>(_ jsonString: String, type: T) -> T? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    let decoder = JSONDecoder()
    return try? decoder.decode(T.self, from: jsonData)
}

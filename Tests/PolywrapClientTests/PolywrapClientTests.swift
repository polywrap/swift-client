import XCTest
@testable import PolywrapClient

final class PolywrapClientTests: XCTestCase {
    struct IncrementArgs: Codable {
        let amount: Int
    }

    struct IncrementResult: Codable {
        let amount: Int
    }

    class CounterPlugin: Plugin {
        var counter: Int = 5

        func addMethod<T: Decodable, U: Codable>(closure: @escaping (T) -> U) -> (Decodable) -> Codable {
            return { (args: Decodable) in
                guard let typedArgs = args as? T else {
                    fatalError("Invalid argument type")
                }
                return closure(typedArgs) as Codable
            }
        }

        override init() {
            super.init()
            methodsMap["increment"] = { (args: Data) -> Codable in
                let decoder = JSONDecoder()
                let incrementArgs = try! decoder.decode(IncrementArgs.self, from: args)
                return self.increment(args: incrementArgs)
            }
        }

        func increment(args: IncrementArgs) -> IncrementResult {
            counter = counter + args.amount

            return IncrementResult(amount: counter)
        }
    }

    func testInvoke() throws {
        let builder = ConfigBuilder()
        let uri = Uri("wrap://ens/counter.eth")!
        let counterPlugin = CounterPlugin()

        builder.addPlugin(uri: uri, plugin: counterPlugin)

        let client = PolywrapClient(clientConfigBuilder: builder)
        let args = IncrementArgs(amount: 4)
        let result = client.invoke(uri: uri, method: "increment", args: args, env: nil)

        print(result)
    }
}

import XCTest
@testable import PolywrapClient

final class PolywrapClientTests: XCTestCase {
    struct IncrementArgs: Decodable {
        let amount: Int
    }

    struct IncrementResult: Codable {
        let amount: Int
    }

    class CounterPlugin: Plugin {
        var counter: Int = 0

        func increment(args: IncrementArgs) -> IncrementResult {
            counter = counter + args.amount

            return IncrementResult(amount: counter)
        }
    }

    func invoke() throws {
        let builder = ConfigBuilder()
        let uri = Uri("wrap://ens/counter.eth")!
        let counterPlugin = CounterPlugin()

        builder.addPlugin(uri: uri, plugin: counterPlugin)

        let client = PolywrapClient(clientConfigBuilder: builder)
        let result = client.invoke(uri: uri, method: "incrementResult", args: "{ \"amount\": 2 }", env: nil)

        print(result)
    }
}

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

        override init() {
            super.init()
            super.addMethod(name: "increment", closure: increment)
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

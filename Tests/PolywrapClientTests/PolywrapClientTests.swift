import XCTest
@testable import PolywrapClient

final class PolywrapClientTests: XCTestCase {
    struct IncrementArgs: Codable {
        let amount: Int
    }

    struct IncrementResult: Codable {
        let amount: Int
    }

    struct SleepArgs: Codable {}

    struct SleepResult: Codable {}

    class CounterPlugin: Plugin {
        var counter: Int = 5

        override init() {
            super.init()
            super.addMethod(name: "increment", closure: increment)
            super.addMethod(name: "sleep", closure: sleep)
        }

        func increment(args: IncrementArgs) -> IncrementResult {
            counter = counter + args.amount
            return IncrementResult(amount: counter)
        }

        func sleep(args: SleepArgs) async -> SleepResult {
            print("before sleeping")

            try! await Task.sleep(nanoseconds: 6000000000)
            print("after sleeping for three seconds :)")

            return SleepResult()
        }
    }

    func testInvoke() throws {
        let builder = ConfigBuilder()
        let counterUri = Uri("wrap://ens/counter.eth")!
        let counterPlugin = CounterPlugin()

        let sleepUri = Uri("wrap://ens/counter.eth")!
        let sleepPlugin = CounterPlugin()

        builder.addPlugin(uri: counterUri, plugin: counterPlugin)
        builder.addPlugin(uri: sleepUri, plugin: sleepPlugin)

        let client = PolywrapClient(clientConfigBuilder: builder)
        let args = IncrementArgs(amount: 4)
        let sleepResult = client.invoke(uri: sleepUri, method: "sleep", args: SleepArgs(), env: nil)
        let result = client.invoke(uri: counterUri, method: "increment", args: args, env: nil)

        print(result)
    }
}

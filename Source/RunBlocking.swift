import Foundation
import AsyncObjects

private final class RunBlocking<T, Failure: Error> {
    fileprivate var value: Result<T, Failure>?
}

extension RunBlocking where Failure == Never {
    func runBlocking(_ operation: @Sendable @escaping () async -> T) -> T {
        let op = TaskOperation {
            let result = await operation()
            self.value = .success(result)
        }

        op.start()
        op.waitUntilFinished()

        switch value {
        case let .success(value):
            return value
        case .none:
            fatalError("Run blocking not received value")
        }
    }
}

extension RunBlocking where Failure == Error {
    func runBlocking(_ operation: @Sendable @escaping () async throws -> T) throws -> T {
        let op = TaskOperation {
            do {
                let result = try await operation()
                self.value = .success(result)
            } catch {
                self.value = .failure(error)
            }
        }

        op.start()
        op.waitUntilFinished()

        switch value {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        case .none:
            fatalError("Run blocking not received value")
        }
    }
}

public func runBlocking<T>(@_implicitSelfCapture _ operation: @Sendable @escaping () async -> T) -> T {
    RunBlocking().runBlocking(operation)
}

public func runBlocking<T>(@_implicitSelfCapture _ operation: @Sendable @escaping () async throws -> T) throws -> T {
    try RunBlocking().runBlocking(operation)
}

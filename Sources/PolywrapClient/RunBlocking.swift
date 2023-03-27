import Foundation

private final class RunBlocking<T, Failure: Error> {
    fileprivate var value: Result<T, Failure>? = nil
    fileprivate let semaphore = DispatchSemaphore(value: 0)
}

extension RunBlocking where Failure == Never {
    func runBlocking(_ operation: @Sendable @escaping () async -> T) -> T {
        Task {
            let result = await operation()
            self.value = .success(result)
            self.semaphore.signal()
        }

        semaphore.wait()

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
        Task {
            do {
                let result = try await operation()
                self.value = .success(result)
            } catch {
                self.value = .failure(error)
            }
            self.semaphore.signal()
        }

        semaphore.wait()

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

func runBlocking<T>(@_implicitSelfCapture _ operation: @Sendable @escaping () async -> T) -> T {
    RunBlocking().runBlocking(operation)
}

func runBlocking<T>(@_implicitSelfCapture _ operation: @Sendable @escaping () async throws -> T) throws -> T {
    try RunBlocking().runBlocking(operation)
}
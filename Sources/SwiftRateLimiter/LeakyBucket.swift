import Foundation

/// A leaky bucket rate limiter implementation using Swift concurrency.
public actor LeakyBucket {
    private let capacity: Int
    private let leakInterval: Duration
    private var queue: [CheckedContinuation<Void, Never>] = []
    private var currentLevel: Int = 0
    private var leakTask: Task<Void, Never>?

    public init(capacity: Int, leakInterval: Duration = .seconds(1)) {
        self.capacity = capacity
        self.leakInterval = leakInterval
    }

    public func submit() async {
        if currentLevel < capacity {
            currentLevel += 1
            startLeakingIfNeeded()
            return
        }
        await withCheckedContinuation { continuation in
            queue.append(continuation)
        }
    }

    private func startLeakingIfNeeded() {
        guard leakTask == nil else { return }
        leakTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: self?.leakInterval ?? .seconds(1))
                await self?.leak()
            }
        }
    }

    private func leak() {
        if currentLevel > 0 { currentLevel -= 1 }
        if !queue.isEmpty { queue.removeFirst().resume() }
        if currentLevel == 0 && queue.isEmpty { leakTask?.cancel(); leakTask = nil }
    }
}

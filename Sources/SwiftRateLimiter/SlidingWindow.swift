import Foundation

/// An actor that tracks request counts in a sliding time window.
public actor SlidingWindowCounter: Sendable {
    public let maxRequests: Int
    public let windowDuration: Duration
    private var timestamps: [ContinuousClock.Instant] = []
    private let clock: ContinuousClock

    public init(maxRequests: Int, windowDuration: Duration, clock: ContinuousClock = ContinuousClock()) {
        precondition(maxRequests > 0, "maxRequests must be positive")
        self.maxRequests = maxRequests
        self.windowDuration = windowDuration
        self.clock = clock
    }

    private func pruneExpired(relativeTo now: ContinuousClock.Instant) {
        timestamps.removeAll { $0 < now - windowDuration }
    }

    public func currentCount() -> Int {
        pruneExpired(relativeTo: clock.now)
        return timestamps.count
    }

    @discardableResult
    public func record() -> Bool {
        let now = clock.now
        pruneExpired(relativeTo: now)
        guard timestamps.count < maxRequests else { return false }
        timestamps.append(now)
        return true
    }

    public func reset() {
        timestamps.removeAll()
    }
}

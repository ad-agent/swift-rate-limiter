import Foundation

/// An actor-isolated token bucket rate limiter using ContinuousClock.
public actor TokenBucket {
    public let capacity: Int
    public let refillRate: Double
    public private(set) var tokens: Double

    private let clock: ContinuousClock
    private var lastRefillInstant: ContinuousClock.Instant

    public init(
        capacity: Int,
        refillRate: Double,
        initialTokens: Double? = nil,
        clock: ContinuousClock = ContinuousClock()
    ) {
        precondition(capacity > 0 && refillRate > 0, "Capacity and refill rate must be positive")
        self.capacity = capacity
        self.refillRate = refillRate
        self.tokens = min(initialTokens ?? Double(capacity), Double(capacity))
        self.clock = clock
        self.lastRefillInstant = clock.now
    }

    public init(policy: RateLimitPolicy, clock: ContinuousClock = ContinuousClock()) {
        self.init(capacity: policy.capacity, refillRate: policy.refillRate, clock: clock)
    }

    private func refill() {
        let now = clock.now
        let duration = now - lastRefillInstant
        let elapsed = Double(duration.components.seconds) + Double(duration.components.attoseconds) * 1e-18
        if elapsed > 0 {
            tokens = min(Double(capacity), tokens + (elapsed * refillRate))
            lastRefillInstant = now
        }
    }

    @discardableResult
    public func tryConsume(_ count: Int = 1) -> Bool {
        precondition(count > 0, "Count must be positive")
        refill()
        guard tokens >= Double(count) else { return false }
        tokens -= Double(count)
        return true
    }

    public func waitForToken() async {
        while !tryConsume(1) {
            refill()
            let needed = max(0.0, 1.0 - tokens)
            let waitSeconds = max(0.001, needed / refillRate)
            try? await clock.sleep(for: .seconds(waitSeconds))
            if Task.isCancelled { return }
        }
    }
}

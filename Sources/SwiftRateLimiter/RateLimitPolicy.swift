import Foundation

/// Presets and configuration for rate limiting policies.
public struct RateLimitPolicy: Sendable, Equatable, Hashable {
    public let capacity: Int
    public let refillRate: Double

    public init(capacity: Int, refillRate: Double) {
        precondition(capacity > 0, "Capacity must be positive")
        precondition(refillRate > 0, "Refill rate must be positive")
        self.capacity = capacity
        self.refillRate = refillRate
    }

    public static func standard(perSecond: Double) -> RateLimitPolicy {
        RateLimitPolicy(capacity: max(1, Int(ceil(perSecond))), refillRate: perSecond)
    }

    public static func burst(capacity: Int, refillRate: Double) -> RateLimitPolicy {
        RateLimitPolicy(capacity: capacity, refillRate: refillRate)
    }
}

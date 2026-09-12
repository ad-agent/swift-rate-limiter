/// Result of a rate limit check.
public struct RateLimitResult: Sendable {
    public let allowed: Bool
    public let remainingTokens: Int
    public let retryAfter: Duration?
    public init(allowed: Bool, remainingTokens: Int, retryAfter: Duration? = nil) {
        self.allowed = allowed
        self.remainingTokens = remainingTokens
        self.retryAfter = retryAfter
    }
}

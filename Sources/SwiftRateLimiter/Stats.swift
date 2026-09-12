import Foundation
/// Tracks rate limit statistics.
public actor RateLimitStats: Sendable {
    public private(set) var allowed = 0
    public private(set) var denied = 0
    public func recordAllowed() { allowed += 1 }
    public func recordDenied() { denied += 1 }
    public var total: Int { allowed + denied }
}

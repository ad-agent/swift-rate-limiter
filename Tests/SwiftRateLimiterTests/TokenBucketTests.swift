import Foundation
import XCTest
@testable import SwiftRateLimiter

final class TokenBucketTests: XCTestCase {
    func testConsumeTokens() async {
        let bucket = TokenBucket(capacity: 5, refillRate: 1.0)
        let consumed = await bucket.tryConsume(3)
        XCTAssertTrue(consumed)
        let remaining = await bucket.tokens
        XCTAssertEqual(remaining, 2.0)

        let failed = await bucket.tryConsume(3)
        XCTAssertFalse(failed)
    }

    func testRefillTokens() async throws {
        let bucket = TokenBucket(capacity: 2, refillRate: 20.0, initialTokens: 0)
        let immediate = await bucket.tryConsume()
        XCTAssertFalse(immediate)

        try await Task.sleep(for: .milliseconds(100))
        let afterRefill = await bucket.tryConsume()
        XCTAssertTrue(afterRefill)
    }

    func testWaitForToken() async {
        let bucket = TokenBucket(capacity: 1, refillRate: 50.0, initialTokens: 0)
        await bucket.waitForToken()
        let available = await bucket.tokens
        XCTAssertGreaterThanOrEqual(available, 0.0)
    }
}

# SwiftRateLimiter

A production-ready rate limiting library for Swift, featuring token bucket and sliding window algorithms with Swift 6 strict concurrency.

## Features

- **Swift 6 Concurrency**: Actor-isolated and `Sendable` types.
- **Clock Driven**: Uses `ContinuousClock` and `Duration` for drift-free timing.
- **Token Bucket**: Thread-safe token replenishment with async/await support.
- **Sliding Window**: Request counting within sliding time windows.
- **Zero Dependencies**: Pure Swift with no third-party dependencies.

## Installation

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ad-agent/swift-rate-limiter.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftRateLimiter

// Token Bucket
let bucket = TokenBucket(capacity: 10, refillRate: 2.0)
if await bucket.tryConsume() { /* process request */ }
await bucket.waitForToken()

// Presets
let standard = TokenBucket(policy: .standard(perSecond: 10.0))
let burst = TokenBucket(policy: .burst(capacity: 50, refillRate: 5.0))

// Sliding Window Counter
let window = SlidingWindowCounter(maxRequests: 100, windowDuration: .seconds(60))
if await window.record() { /* allowed */ }
```

## License

MIT License. See [LICENSE](LICENSE) for details.

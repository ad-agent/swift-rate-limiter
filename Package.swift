import Foundation
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftRateLimiter",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftRateLimiter",
            targets: ["SwiftRateLimiter"]
        )
    ],
    targets: [
        .target(
            name: "SwiftRateLimiter"
        ),
        .testTarget(
            name: "SwiftRateLimiterTests",
            dependencies: ["SwiftRateLimiter"]
        )
    ],
    swiftLanguageModes: [.v6]
)

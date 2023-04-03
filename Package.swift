// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "fanout-starter-kit",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "2.16.0")
    ],
    targets: [
        .executableTarget(name: "App", dependencies: ["Compute"])
    ]
)

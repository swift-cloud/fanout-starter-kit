// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "fanout-starter-kit",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "2.17.0")
    ],
    targets: [
        .executableTarget(name: "App", dependencies: ["Compute"])
    ]
)

// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "fanout-starter-kit",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", branch: "ab/fanout")
    ],
    targets: [
        .executableTarget(name: "App", dependencies: ["Compute"])
    ]
)

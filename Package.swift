// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
	platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "NetworkAPI", targets: ["NetworkAPI"]),
        .library(name: "Network", targets: ["Network"]),
        .library(name: "NetworkMocks", targets: ["NetworkMocks"])
    ],
    targets: [
        .target(name: "NetworkAPI"),
        .target(name: "Network", dependencies: ["NetworkAPI"]),
        .target(name: "NetworkMocks", dependencies: ["NetworkAPI"]),
        .testTarget(name: "NetworkAPITests", dependencies: ["NetworkAPI"]),
        .testTarget(name: "NetworkTests", dependencies: ["Network", "NetworkMocks"])
    ],
	swiftLanguageVersions: [.v5]
)

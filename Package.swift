// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ThemedControls",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "ThemedControls", targets: ["ThemedControls"]),
    ],
    targets: [
        .target(name: "ThemedControls", path: "Sources",
                swiftSettings: [.swiftLanguageMode(.v6), .defaultIsolation(MainActor.self)]),
        .testTarget(name: "ThemedControlsTests", dependencies: ["ThemedControls"], path: "Tests",
                    swiftSettings: [.swiftLanguageMode(.v6)]),
    ]
)

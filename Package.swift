// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RoomMac",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "RoomMac",
            path: "Sources/RoomMac"
        )
    ]
)

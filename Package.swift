// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "GoogleCloudKit",
    platforms: [ .macOS(.v10_14)],
    products: [
         .library(
             name: "GoogleCloudCore",
             targets: ["Core"]
         ),
         .library(
             name: "GoogleCloudStorage",
             targets: ["Storage"]
         ),
        .library(
            name: "GoogleCloudKit",
            targets: ["Core", "Storage"]
        ),
        .library(
            name: "DiscoveryCodeGen",
            targets: ["CodeGen"]
        ),
        .executable(
            name: "codegen-cli",
            targets: ["CLI"]
            ),
        .executable(
        name: "testingModules",
        targets: ["testingModules"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-beta")
    ],
    targets: [
        .target(
            name: "testingModules",
            dependencies: ["AsyncHTTPClient", "JWTKit", "NIOFoundationCompat"],
            path: "testingModules/"
        ),
        .target(
            name: "CodeGen",
            dependencies: [],
            path: "CodeGen/"
        ),
        .target(
            name: "CLI",
            dependencies: [],
            path: "codegen-cli/"
        ),
        
        .target(
            name: "Core",
            dependencies: ["AsyncHTTPClient", "JWTKit", "NIOFoundationCompat"],
            path: "Core/Sources/"
        ),
        .target(
            name: "Storage",
            dependencies: ["Core"],
            path: "Storage/Sources/"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core", "AsyncHTTPClient"],
            path: "Core/Tests/"
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Storage"],
            path: "Storage/Tests/"
        ),
    ]
)

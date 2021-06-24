// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright (c) native.dev.br. All rights reserved.
// Licensed under the Apache 2.0 License. See LICENSE file in the project root for full license information.

import PackageDescription

let package = Package(
  name: "ErrorReporting",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_10),
    .tvOS(.v10),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "ErrorReporting",
      targets: ["ErrorReporting"])
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.8.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "ErrorReporting",
      dependencies: []),
    .testTarget(
      name: "ErrorReportingTests",
      dependencies: ["ErrorReporting", "SnapshotTesting"],
      exclude: ["__Snapshots__"]),
  ]
)

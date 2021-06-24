// Copyright (c) native.dev.br. All rights reserved.
// Licensed under the Apache 2.0 License. See LICENSE file in the project root for full license information.

import SnapshotTesting
import XCTest

@testable import ErrorReporting

final class ErrorReportingTests: XCTestCase {
  func testNSError_EncodableStruct() {
    struct CustomError: Error, Encodable {
      let value: Int
    }

    let nsError = CustomError(value: 10).nsError()
    assertSnapshot(matching: nsError.userInfo, as: .dump)
  }

  func testNSError_Struct() {
    struct CustomError: Error {
      let value: Int
    }

    let nsError = CustomError(value: 10).nsError()
    assertSnapshot(matching: nsError.userInfo, as: .dump)
  }

  func testNSError_Enum() {
    enum CustomError: Error {
      case first(Int)
      case second(String)
    }

    var nsError = CustomError.first(10).nsError()
    assertSnapshot(matching: nsError.userInfo, as: .dump)

    nsError = CustomError.second("10").nsError()
    assertSnapshot(matching: nsError.userInfo, as: .dump)
  }
}

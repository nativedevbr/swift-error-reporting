import Foundation

public struct ErrorReporting {

  public static var main: ErrorReporting {
    get {
      precondition(
        _main != nil, "'ErrorReporting.main' not defined, please set a value before using it.")
      return _main.unsafelyUnwrapped
    }
    set {
      _main = newValue
    }
  }

  private static var _main: ErrorReporting?

  private let destinations: [Destination]

  public init(destinations: [Destination]) {
    self.destinations = destinations
  }

  public struct Destination {
    public var send: (Report) -> Void

    public init(send: @escaping (Report) -> Void) {
      self.send = send
    }
  }

  public func report(
    _ error: Error,
    function: StaticString = #function,
    file: StaticString = #fileID,
    line: UInt = #line,
    context: Any? = nil
  ) {
    let report = Report(error: error, function: function, file: file, line: line, context: context)
    destinations.forEach {
      $0.send(report)
    }
  }
}

public struct Report {
  public let error: Error
  public let function: StaticString
  public let file: StaticString
  public let line: UInt
  public let context: Any?

  var json: [String: Any] {
    [
      "error": error,
      "function": function,
      "file": file,
      "line": line,
      "context": context as Any,
    ]
  }
}

extension ErrorReporting.Destination {

  public static let console = ErrorReporting.Destination { report in
    #if DEBUG
      print("🚨 Error: \(report.json)")
    #endif
  }
}

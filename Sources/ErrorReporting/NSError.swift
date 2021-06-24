import Foundation

/// Key used to lookup the user info's NSError for the internal representation of the error.
/// The value returned by the lookup is a `[String: Any]?`.
public let InternalErrorInfoKey = "InternalError"

/// Key used to lookup the user info's NSError for the location where error ocurred in code.
/// The value returned by the lookup is a `[String: Any]?`.
public let ErrorLocationInfoKey = "ErrorLocation"

extension Report {
  /// NSError reprensetation of the error being reported.
  ///
  /// It tries to build a representation using `JSONEncoder` if the error implements the `Encodable` protocol.
  /// Otherwise, it builds the representation by using reflection.
  ///
  /// Example of a NSError returned:
  /// ```
  /// struct MyCustomError: Error, Encodable {
  ///     let someProperty: String
  /// }
  ///
  /// NSError(
  ///     domain: "MyCustomError",
  ///     code: "1",
  ///     userInfo: [
  ///         "InternalError": [
  ///             "someProperty": "some string value"
  ///         ],
  ///         "ErrorLocation": [
  ///             "function": "veryImportantFunction()"
  ///             "file": "MyModule/MyFile.swift"
  ///             "line": 4
  ///             "context": // Any additional context proviced, can be anything.
  ///         ]
  ///     ]
  /// )
  /// ```
  public func nsError() -> NSError {
    let nsError = error as NSError
    var userInfo = nsError.userInfo

    if let error = error as? Encodable,
      let data = try? JSONEncoder().encode(AnyEncodable(value: error))
    {
      userInfo[InternalErrorInfoKey] = try? JSONSerialization.jsonObject(with: data, options: [])
    } else {
      let mirror = Mirror(reflecting: error)
      let childrenDict = mirror.children.compactMap {
        $0.label != nil
          ? ($0.label!, $0.value)
          : nil
      }
      userInfo[InternalErrorInfoKey] = Dictionary(uniqueKeysWithValues: childrenDict)
    }

    userInfo[ErrorLocationInfoKey] = [
      "function": function,
      "file": file,
      "line": line,
      "context": context as Any,
    ]

    return NSError(
      domain: nsError.domain,
      code: nsError.code,
      userInfo: userInfo
    )
  }
}

struct AnyEncodable: Encodable {
  var value: Encodable

  func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
}

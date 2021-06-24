# ErrorReporting

A description of this package. 
TBD.

## Examples

### SentrySDK integration

```swift
extension ErrorReporting.Destination {
  static let sentry = ErrorReporting.Destination { report in 
    SentrySDK.capture(error: report.nsError())
  }
}
```

### Crashlytics integration
```swift
extension ErrorReporting.Destination {
  static let crashlytics = ErrorReporting.Destination { report in 
    Crashlytics.crashlytics().record(error: report.nsError())
  }
}
```

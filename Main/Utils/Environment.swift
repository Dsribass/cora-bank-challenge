import Foundation

struct EnvironmentVariables {
  static let apikey = ProcessInfo.processInfo.environment["apikey"] ?? ""
}

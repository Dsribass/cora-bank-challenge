import Foundation

public enum DomainError: Error, Equatable {
  case notAuthorized
  case noConnection
  case unexpected
}

public enum ValidationError: Error {
  case invalid, empty
}

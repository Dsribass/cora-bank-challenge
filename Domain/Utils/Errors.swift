public enum DomainError: Error {
  case notAuthorized
  case noConnection
  case unexpected(baseError: Error?)
}

public enum ValidationError: Error {
  case invalid, empty
}

import Foundation

public enum DomainError: Error, Equatable {
  case notAuthorized
  case noConnection
  case nonexistentItem
  case inputInvalid, inputEmpty
  case unexpected(originalErrorDescription: String)
}

extension DomainError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notAuthorized: return "You are not authorized to perform this action."
    case .noConnection: return "There is no internet connection."
    case .nonexistentItem: return "The item does not exist."
    case .inputInvalid: return "The input is invalid."
    case .inputEmpty: return "The input is empty."
    case .unexpected(let description): 
      return "An unexpected error occurred. \(description)"
    }
  }
}

extension DomainError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .notAuthorized:
      return NSLocalizedString(
        "You are not authorized to perform this action.",
        comment: "DomainError: notAuthorized"
      )
    case .noConnection:
      return NSLocalizedString(
        "There is no internet connection.",
        comment: "DomainError: noConnection"
      )
    case .nonexistentItem:
      return NSLocalizedString(
        "The item does not exist.",
        comment: "DomainError: nonexistentItem"
      )
    case .inputInvalid:
      return NSLocalizedString(
        "The input is invalid.", 
        comment: "DomainError: inputInvalid"
      )
    case .inputEmpty:
      return NSLocalizedString(
        "The input is empty.",
        comment: "DomainError: inputEmpty"
      )
    case .unexpected(let description):
      return NSLocalizedString(
        "An unexpected error occurred. \(description)",
        comment: "DomainError: unexpected"
            )
    }
  }
}

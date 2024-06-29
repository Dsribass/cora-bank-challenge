import Foundation
import Combine
import Domain

protocol DataError: Error {}

enum CommonError: DataError {
  case itemNotFound
  case unexpected
}

enum NetworkError: DataError {
  case unauthorized
  case forbidden
  case badRequest
  case notFound
  case serverError
  case noConnectivity
  case encodingError
  case unexpected(baseError: Error?)
}

extension Publisher where Failure == Error {
  func mapToDomainError() -> AnyPublisher<Output, DomainError> {
    mapError { error in
      let errorDescription = "\(error).\n\(error.localizedDescription)"

      if let error = error as? NetworkError {
        switch error {
        case .unauthorized:
          return .notAuthorized
        case .noConnectivity:
          return .noConnection
        default:
          return .unexpected(originalErrorDescription: errorDescription)
        }
      } else {
        return .unexpected(originalErrorDescription: errorDescription)
      }
    }
    .eraseToAnyPublisher()
  }
}

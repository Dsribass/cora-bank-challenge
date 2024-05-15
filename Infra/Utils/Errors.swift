import Foundation
import Combine
import Domain

protocol DataError: Error {}

enum CommonError: DataError {
  case itemNotFound
}

enum NetworkError: DataError {
  case unauthorized
  case forbidden
  case badRequest
  case notFound
  case serverError
  case noConnectivity
  case decodingError
  case unexpected(baseError: Error?)
}

extension AnyPublisher where Failure == Error {
  func mapToDomainError() -> AnyPublisher<Output, DomainError> {
    mapError { error in
      if let error = error as? NetworkError {
        switch error {
        case .unauthorized:
          return .notAuthorized
        case .noConnectivity:
          return .noConnection
        default:
          return .unexpected(baseError: error)
        }
      } else {
        return .unexpected(baseError: error)
      }
    }
    .eraseToAnyPublisher()
  }
}

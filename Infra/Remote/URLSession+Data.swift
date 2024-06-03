import Foundation
import Combine

extension URLSession.DataTaskPublisher {
  func tryMapToData() -> AnyPublisher<Data, Error> {
    mapError { error -> Error in
      if error.code == .notConnectedToInternet {
        return NetworkError.noConnectivity
      }
      return error
    }
    .tryMap() { element -> Data in
      guard let httpResponse = element.response as? HTTPURLResponse else {
        throw NetworkError.serverError
      }

      switch httpResponse.statusCode {
      case 200..<300:
        return element.data
      case 401:
        throw NetworkError.unauthorized
      case 403:
        throw NetworkError.forbidden
      case 404:
        throw NetworkError.notFound
      case 400...499:
        throw NetworkError.badRequest
      case 500...599:
        throw NetworkError.serverError
      default:
        throw NetworkError.serverError
      }
    }
    .eraseToAnyPublisher()
  }
}

import Foundation
import Combine

public final class AuthRemoteDataSource {
  public init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  private let networkManager: NetworkManager

  func loadToken(_ token: String) {
    networkManager.setToken(token)
  }

  func authenticate(request: UserRemoteModel.Request) -> AnyPublisher<String, Error> {
    networkManager.unlockQueue()
    networkManager.unsetToken()

    guard let body = try? JSONEncoder().encode(request) else {
      return AnyPublisher(Fail<String, Error>(error: NetworkError.encodingError))
    }

    return networkManager
      .post(
        for: URLBuilder.auth(),
        body: body,
        shouldWaitForPriorityRequest: false
      )
      .decode(type: UserRemoteModel.Response.self, decoder: JSONDecoder())
      .map { [unowned self] response in
        networkManager.setToken(response.token)
        return response.token
      }
      .eraseToAnyPublisher()
  }

  func refreshToken(request: TokenRemoteModel.Request) -> AnyPublisher<String, Error> {
    networkManager.blockQueue()
    networkManager.unsetToken()

    guard let body = try? JSONEncoder().encode(request) else {
      return AnyPublisher(Fail<String, Error>(error: NetworkError.encodingError))
    }

    return networkManager
      .post(
        for: URLBuilder.auth(),
        body: body,
        shouldWaitForPriorityRequest: false
      )
      .decode(type: TokenRemoteModel.Response.self, decoder: JSONDecoder())
      .map { [unowned self] response in
        networkManager.setToken(response.token)
        networkManager.unlockQueue()
        return response.token
      }
      .mapError { [unowned self] error in
        networkManager.unlockQueue()
        return error
      }
      .eraseToAnyPublisher()
  }
}

import Foundation
import Combine

public final class AuthLocalDataSource {
  public init(defaults: UserDefaults) {
    self.defaults = defaults
  }

  private let defaults: UserDefaults

  private struct Keys {
    static let token = "token"
  }

  func saveUserToken(_ token: String) -> AnyPublisher<(), Error> {
    Future { [weak defaults] promise in
      defaults?.set(token, forKey: Keys.token)
      promise(.success(()))
    }.eraseToAnyPublisher()
  }

  func getUserToken() -> AnyPublisher<String, Error> {
    Future { [weak defaults] promise in
      guard let token = defaults?.string(forKey: Keys.token) else {
        return promise(.failure(CommonError.itemNotFound))
      }

      promise(.success(token))
    }.eraseToAnyPublisher()
  }

  func deleteUserToken() -> AnyPublisher<(), Error> {
    Future { [weak defaults] promise in
      defaults?.removeObject(forKey: Keys.token)

      promise(.success(()))
    }.eraseToAnyPublisher()
  }
}

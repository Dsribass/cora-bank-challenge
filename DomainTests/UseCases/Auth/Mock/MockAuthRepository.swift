import Combine
@testable import Domain

class MockAuthRepository: AuthRepository {
  var authenticateResult: AnyPublisher<(), DomainError> =
  Fail(outputType: Void.self, failure: DomainError.unexpected(originalErrorDescription: ""))
    .eraseToAnyPublisher()

  var loadUserTokenResult: AnyPublisher<(), DomainError> =
  Fail(outputType: Void.self, failure: DomainError.unexpected(originalErrorDescription: ""))
    .eraseToAnyPublisher()

  var logOutResult: AnyPublisher<(), DomainError> =
  Fail(outputType: Void.self, failure: DomainError.unexpected(originalErrorDescription: ""))
    .eraseToAnyPublisher()

  var refreshTokenResult: AnyPublisher<(), DomainError> =
  Fail(outputType: Void.self, failure: DomainError.unexpected(originalErrorDescription: ""))
    .eraseToAnyPublisher()

  func authenticate(user: (cpf: String, password: String)) -> AnyPublisher<(), DomainError> {
    return authenticateResult
  }

  func loadUserToken() -> AnyPublisher<(), DomainError> {
    return loadUserTokenResult
  }

  func logOut() -> AnyPublisher<(), DomainError> {
    return logOutResult
  }

  func refreshToken() -> AnyPublisher<(), DomainError> {
    return refreshTokenResult
  }
}

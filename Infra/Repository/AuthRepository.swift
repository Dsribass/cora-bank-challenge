import Domain
import Combine

public final class AuthRepository: AuthRepositoryProtocol {
  public init(authRDS: AuthRemoteDataSource, authLDS: AuthLocalDataSource) {
    self.authRDS = authRDS
    self.authLDS = authLDS
  }

  private let authRDS: AuthRemoteDataSource
  private let authLDS: AuthLocalDataSource

  public func authenticate(user: (cpf: String, password: String)) -> AnyPublisher<(), DomainError> {
    authRDS.authenticate(
      request: AuthRemoteDataSource.Request(cpf: user.cpf, password: user.password)
    )
    .flatMap { self.authLDS.saveUserToken($0) }
    .eraseToAnyPublisher()
    .mapToDomainError()
  }
}

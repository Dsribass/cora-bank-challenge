import Combine
import Foundation

public final class LoadAuthState: UseCase {
  public init(authRepository: AuthRepository, authPublisher: AuthStatePublisher) {
    self.authRepository = authRepository
    self.authPublisher = authPublisher
  }

  private let authRepository: AuthRepository
  private let authPublisher: AuthStatePublisher

  public func runBlock(_ req: ()) -> AnyPublisher<(), DomainError> {
    authRepository.loadUserToken()
      .map { [weak self] value in
        guard let self = self else { return value }
        authPublisher.send(.loggedIn)

        return value
      }
      .mapError { [weak self] error in
        guard let self = self else { return error }
        authPublisher.send(.loggedOut)

        return error
      }
      .eraseToAnyPublisher()
  }
}

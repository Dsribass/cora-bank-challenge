import Combine

public final class LogOutUser: UseCase {
  public init(authRepository: AuthRepository, authPublisher: AuthStatePublisher) {
    self.authRepository = authRepository
    self.authPublisher = authPublisher
  }

  private let authRepository: AuthRepository
  private let authPublisher: AuthStatePublisher

  public func runBlock(_ req: ()) -> AnyPublisher<(), DomainError> {
    authRepository.logOut()
      .map { [weak self] value in
        self?.authPublisher.send(.loggedOut)
        return value
      }      
      .eraseToAnyPublisher()
  }
}

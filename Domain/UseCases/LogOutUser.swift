import Combine

public final class LogOutUser {
  public init(authRepository: AuthRepositoryProtocol, authPublisher: CurrentValueSubject<AuthState, Never>) {
    self.authRepository = authRepository
    self.authPublisher = authPublisher
  }

  private let authRepository: AuthRepositoryProtocol
  private let authPublisher: CurrentValueSubject<AuthState, Never>

  public func execute(_ req: ()) -> AnyPublisher<(), Never> {
    authRepository.logOut()
      .handleEvents(
        receiveCompletion: { [weak self ] _ in
          self?.authPublisher.send(.loggedOut)
      })
      .catch{ _ in Just(()) }
      .eraseToAnyPublisher()
  }
}

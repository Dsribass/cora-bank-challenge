import Combine

// TODO(any): Implement authenticate usecase
public final class AuthenticateUser {
  public struct Request {
    public init(cpf: String, password: String) {
      self.cpf = cpf
      self.password = password
    }

    public let cpf: String
    public let password: String
  }

  public init(authRepository: AuthRepositoryProtocol, authPublisher: CurrentValueSubject<AuthState, Never>) {
    self.authRepository = authRepository
    self.authPublisher = authPublisher
  }

  private let authRepository: AuthRepositoryProtocol
  private let authPublisher: CurrentValueSubject<AuthState, Never>

  public func execute(_ req: Request) -> AnyPublisher<(), DomainError> {
    authRepository.authenticate(user: (cpf: req.cpf, password: req.password))
      .map { [weak self] value in
        self?.authPublisher.send(.loggedIn)
        return value
      }
      .eraseToAnyPublisher()
  }
}

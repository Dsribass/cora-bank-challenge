import Combine

public final class AuthenticateUser: UseCase {
  public struct Request {
    public init(cpf: String, password: String) {
      self.cpf = cpf
      self.password = password
    }

    public let cpf: String
    public let password: String
  }

  public init(authRepository: AuthRepository, authPublisher: AuthStatePublisher) {
    self.authRepository = authRepository
    self.authPublisher = authPublisher
  }

  private let authRepository: AuthRepository
  private let authPublisher: AuthStatePublisher

  public func runBlock(_ req: Request) -> AnyPublisher<(), DomainError> {
    authRepository.authenticate(user: (cpf: req.cpf, password: req.password))
      .map { [weak self] value in
        self?.authPublisher.send(.loggedIn)
        return value
      }
      .eraseToAnyPublisher()
  }
}

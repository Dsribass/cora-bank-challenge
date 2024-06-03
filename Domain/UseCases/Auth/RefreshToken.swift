import Combine

public final class RefreshToken {
  public init(authRepository: AuthRepositoryProtocol) {
    self.authRepository = authRepository
  }

  private let authRepository: AuthRepositoryProtocol

  public func execute(_ req: ()) -> AnyPublisher<(), DomainError> {
    authRepository.refreshToken()
  }
}

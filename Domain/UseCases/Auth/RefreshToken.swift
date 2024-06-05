import Combine

public final class RefreshToken: UseCase {
  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  private let authRepository: AuthRepository

  public func runBlock(_ req: ()) -> AnyPublisher<(), DomainError> {
    authRepository.refreshToken()
  }
}

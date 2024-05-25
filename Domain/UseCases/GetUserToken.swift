import Combine

public final class GetUserToken {
  public init(authRepository: AuthRepositoryProtocol) {
    self.authRepository = authRepository
  }

  private let authRepository: AuthRepositoryProtocol

  public func execute(_ req: ()) -> AnyPublisher<String, DomainError> {
    authRepository.getUserToken()
  }
}

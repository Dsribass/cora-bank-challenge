import Combine

public protocol AuthRepositoryProtocol {
  func authenticate(user: (cpf: String, password: String)) -> AnyPublisher<(), DomainError>
}

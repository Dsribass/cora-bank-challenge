import Combine

public protocol AuthRepositoryProtocol {
  func authenticate(user: (cpf: String, password: String)) -> AnyPublisher<(), DomainError>
  
  func getUserToken() -> AnyPublisher<String, DomainError>

  func logOut() -> AnyPublisher<(), DomainError>
}

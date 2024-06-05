import Combine

public protocol AuthRepository {
  func authenticate(user: (cpf: String, password: String)) -> AnyPublisher<(), DomainError>
  
  func loadUserToken() -> AnyPublisher<(), DomainError>

  func logOut() -> AnyPublisher<(), DomainError>

  func refreshToken() -> AnyPublisher<(), DomainError>
}

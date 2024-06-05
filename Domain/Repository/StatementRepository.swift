import Combine

public protocol StatementRepository {
  func getStatementList() -> AnyPublisher<[StatementsByDate], DomainError>
}

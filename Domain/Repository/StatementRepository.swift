import Combine

public protocol StatementRepository {
  func getStatementList() -> AnyPublisher<[StatementsByDate], DomainError>
  func getStatementDetail(id: String) -> AnyPublisher<Statement, DomainError>
}

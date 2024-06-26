import Combine
import Domain

public class DefaultStatementRepository: StatementRepository {
  public init(statementRDS: StatementRemoteDataSource) {
    self.statementRDS = statementRDS
  }

  private let statementRDS: StatementRemoteDataSource

  public func getStatementList() -> AnyPublisher<[StatementsByDate], DomainError> {
    statementRDS.getStatementList()
      .tryMap { response in try response.toDM() }
      .mapToDomainError()
      .eraseToAnyPublisher()
  }

  public func getStatementDetail(id: String) -> AnyPublisher<Statement, DomainError> {
    statementRDS.getStatementDetail(id: id)
      .tryMap { response in try response.toDM() }
      .mapToDomainError()
      .eraseToAnyPublisher()
  }
}

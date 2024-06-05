import Combine

public final class GetStatementList: UseCase {
  public init(statementRepository: StatementRepository) {
    self.statementRepository = statementRepository
  }

  private let statementRepository: StatementRepository

  public func runBlock(_ req: ()) -> AnyPublisher<[StatementsByDate], DomainError> {
    statementRepository.getStatementList()
  }
}

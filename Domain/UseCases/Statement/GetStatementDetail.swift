import Combine

public final class GetStatementDetail: UseCase {
  public struct Request {
    public init(id: String) {
      self.id = id
    }
    public let id: String
  }

  public init(statementRepository: StatementRepository) {
    self.statementRepository = statementRepository
  }

  private let statementRepository: StatementRepository

  public func runBlock(_ req: Request) -> AnyPublisher<Statement, DomainError> {
    statementRepository.getStatementDetail(id: req.id)
  }
}

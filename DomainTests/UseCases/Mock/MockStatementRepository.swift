import Combine
import Foundation
import Domain

class MockStatementRepository: StatementRepository {
    var getStatementListResult: AnyPublisher<[StatementsByDate], DomainError> =
    Fail(outputType: [StatementsByDate].self, failure: DomainError.unexpected(originalErrorDescription: ""))
        .eraseToAnyPublisher()

    var getStatementDetailResult: AnyPublisher<Statement, DomainError> =
    Fail(outputType: Statement.self, failure: DomainError.unexpected(originalErrorDescription: ""))
        .eraseToAnyPublisher()

    func getStatementList() -> AnyPublisher<[StatementsByDate], DomainError> {
        return getStatementListResult
    }

    func getStatementDetail(id: String) -> AnyPublisher<Statement, DomainError> {
        return getStatementDetailResult
    }
}

//
//  GetStatementListTest.swift
//  DomainTests
//
//  Created by Daniel de Souza Ribas on 31/07/24.
//

import XCTest
import Combine
@testable import Domain

final class GetStatementListTest: XCTestCase {
  private var sut: GetStatementList!
  private var mockStatementRepository: MockStatementRepository!

  override func setUpWithError() throws {
    mockStatementRepository = MockStatementRepository()
    sut = GetStatementList(statementRepository: mockStatementRepository)
  }

  override func tearDownWithError() throws {
    mockStatementRepository = nil
    sut = nil
  }

  func test_getStatementList_successCase() throws {
    mockStatementRepository.getStatementListResult = Just([dummyStatementsByDate])
      .setFailureType(to: DomainError.self)
      .eraseToAnyPublisher()

    let result = try awaitPublisher(sut.execute(()))

    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result.first?.date, dummyStatementsByDate.date)
    XCTAssertEqual(result.first?.statements.count, dummyStatementsByDate.statements.count)
    XCTAssertEqual(result.first?.statements.first?.id, dummyStatementsByDate.statements.first?.id)
  }

  func test_getStatementList_failureCase() throws {
    mockStatementRepository.getStatementListResult = Fail(error: DomainError.unexpected(originalErrorDescription: ""))
      .eraseToAnyPublisher()

    XCTAssertThrowsError(try awaitPublisher(sut.execute(()))) { error in
      XCTAssertEqual(error as? DomainError, DomainError.unexpected(originalErrorDescription: ""))
    }
  }
}

private let dummyParty = Statement.Party(
  bankName: "Bank A",
  bankNumber: "001",
  documentNumber: "12345678901",
  documentType: "CPF",
  accountNumberDigit: "0",
  agencyNumberDigit: "1",
  agencyNumber: "1234",
  name: "John Doe",
  accountNumber: "567890"
)

private let dummyStatement = Statement(
  description: "Compra no supermercado",
  label: "Alimentos",
  amount: 150.75,
  counterPartyName: "Supermercado XYZ",
  id: "stmt_001",
  dateEvent: Date(),
  recipient: dummyParty,
  sender: dummyParty,
  status: .completed
)

private let dummyStatementSummary = StatementSummary(
  id: "stmt_001",
  description: "Compra no supermercado",
  label: "Alimentos",
  entry: .debit,
  amount: 150.75,
  name: "Supermercado XYZ",
  dateEvent: Date(),
  status: .completed
)

private let dummyStatementsByDate: StatementsByDate = (statements: [dummyStatementSummary], date: Date())



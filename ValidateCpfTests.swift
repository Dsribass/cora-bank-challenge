//
//  ValidateCpfTests.swift
//  DomainTests
//
//  Created by Daniel de Souza Ribas on 13/06/24.
//

import XCTest
import Combine
@testable import Domain

final class ValidateCpfTests: XCTestCase {
  private var sut: ValidateCpf!
  private var subscriptions: Set<AnyCancellable>!

  private let emptyCpf = ValidateCpf.Request(cpf: "")
  private let validCpf = ValidateCpf.Request(cpf: "76626692038")
  private let uncleanedCpf = ValidateCpf.Request(cpf: "766.266.920-38")
  private let invalidCpf = ValidateCpf.Request(cpf: "11111111111")
  private let cpfWithBiggerLength = ValidateCpf.Request(cpf: "766266920381")

  override func setUpWithError() throws {
    sut = ValidateCpf()
    subscriptions = []
  }

  override func tearDownWithError() throws {
    sut = nil
    subscriptions.removeAll()
  }

  func test_validateCpf_withValidValue_shouldFinishSuccessfully() throws {
    try awaitPublisher(sut.execute(validCpf))
  }

  func test_validateCpf_withNotCleanedValue_shouldFinishSuccessfully() throws {
    try awaitPublisher(sut.execute(uncleanedCpf))
  }

  func test_validateCpf_withEmptyValue_shouldThrowInputEmpty() throws {
    XCTAssertThrowsError(try awaitPublisher(sut.execute(emptyCpf))) { error in
      XCTAssertEqual(error as? DomainError, DomainError.inputEmpty)
    }
  }

  func test_validateCpf_withBiggerLength_shouldThrowInputInvalid() throws {
    XCTAssertThrowsError(try awaitPublisher(sut.execute(cpfWithBiggerLength))) { error in
      XCTAssertEqual(error as? DomainError, DomainError.inputInvalid)
    }
  }

  func test_validateCpf_withInvalidValue_shouldThrowInputInvalid() throws {
    XCTAssertThrowsError(try awaitPublisher(sut.execute(invalidCpf))) { error in
      XCTAssertEqual(error as? DomainError, DomainError.inputInvalid)
    }
  }
}

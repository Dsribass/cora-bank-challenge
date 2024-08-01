//
//  AuthenticateUserTests.swift
//  DomainTests
//
//  Created by Daniel de Souza Ribas on 20/07/24.
//

import XCTest
import Combine
@testable import Domain

class AuthenticateUserTests: XCTestCase {
  private var sut: AuthenticateUser!
  private var mockAuthRepository: MockAuthRepository!
  private var authPublisher: AuthStatePublisher!

  private var dummyRequest: AuthenticateUser.Request = .init(cpf: "00000000000", password: "12345678")

  override func setUpWithError() throws {
    mockAuthRepository = MockAuthRepository()
    authPublisher = AuthStatePublisher(nil)
    sut = AuthenticateUser(authRepository: mockAuthRepository, authPublisher: authPublisher)
  }

  override func tearDownWithError() throws {
    mockAuthRepository = nil
    authPublisher = nil
    sut = nil
  }

  func test_authenticateUser_withSuccessAuthentication_shouldEmitLoggedIn() throws {
    let spy = AuthStateSpy(authPublisher)
    mockAuthRepository.authenticateResult = Just(()).setFailureType(to: DomainError.self).eraseToAnyPublisher()

    XCTAssertEqual(spy.values, [nil])

    try awaitPublisher(sut.execute(dummyRequest))

    XCTAssertEqual(spy.values, [nil, .loggedIn])
  }

  func test_authenticateUser_withFailAuthentication_shouldEmitNothing() throws {
    let spy = AuthStateSpy(authPublisher)
    XCTAssertEqual(spy.values, [nil])

    XCTAssertThrowsError(try awaitPublisher(sut.execute(dummyRequest)))
    XCTAssertEqual(spy.values, [nil])
  }
}

private class AuthStateSpy {
  private var cancellable: AnyCancellable?
  var values: [AuthState?] = []

  init(_ publisher: AuthStatePublisher) {
    cancellable = publisher.sink { [weak self] state in
      self?.values.append(state)
    }
  }
}

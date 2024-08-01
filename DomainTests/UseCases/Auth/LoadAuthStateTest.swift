//
//  LoadAuthStateTest.swift
//  DomainTests
//
//  Created by Daniel de Souza Ribas on 31/07/24.
//

import XCTest
import Combine
@testable import Domain

final class LoadAuthStateTest: XCTestCase {
  private var sut: LoadAuthState!
  private var mockAuthRepository: MockAuthRepository!
  private var authPublisher: AuthStatePublisher!


  override func setUpWithError() throws {
    mockAuthRepository = MockAuthRepository()
    authPublisher = AuthStatePublisher(nil)
    sut = LoadAuthState(authRepository: mockAuthRepository, authPublisher: authPublisher)
  }

  override func tearDownWithError() throws {
    mockAuthRepository = nil
    authPublisher = nil
    sut = nil
  }

  func test_loadAuthState_withSavedUserToken_shouldEmitLoggedIn() throws {
    let spy = AuthStateSpy(authPublisher)
    mockAuthRepository.loadUserTokenResult = Just(()).setFailureType(to: DomainError.self).eraseToAnyPublisher()

    XCTAssertEqual(spy.values, [nil])

    try awaitPublisher(sut.execute(()))

    XCTAssertEqual(spy.values, [nil, .loggedIn])
  }

  func test_loadAuthState_withoutUserToken_shouldEmitLoggedOut() throws {
    let spy = AuthStateSpy(authPublisher)

    XCTAssertEqual(spy.values, [nil])

    XCTAssertThrowsError(try awaitPublisher(sut.execute(())))
    XCTAssertEqual(spy.values, [nil, .loggedOut])
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

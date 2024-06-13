import Combine
import Foundation
import Domain

class StatementDetailViewModel: ViewModel {
  enum StatementDetailState: State {
    case loading, loaded(Statement), error
  }
  enum StatementDetailAction: Action {}
  enum StatementDetailEvent: Event {
    case loadStatement
  }

  var subscriptions: Set<AnyCancellable> = []
  var stateSubject: CurrentValueSubject<StatementDetailState, Never> = .init(.loading)
  var actionSubject: PassthroughSubject<StatementDetailAction, Never> = .init()

  init(id: String, getStatementDetail: GetStatementDetail) {
    self.id = id
    self.getStatementDetail = getStatementDetail

    sendEvent(.loadStatement)
  }

  private let id: String
  private let getStatementDetail: GetStatementDetail

  func sendEvent(_ event: StatementDetailEvent) {
    switch event {
    case .loadStatement: onLoadStatement()
    }
  }
}

extension StatementDetailViewModel {
  func onLoadStatement() {
    stateSubject.send(.loading)
    getStatementDetail.execute(.init(id: id))
      .sink { [weak self] completion in
        if case .failure(_) = completion {
          self?.stateSubject.send(.error)
        }
      } receiveValue: { [weak self] statement in
        self?.stateSubject.send(.loaded(statement))
      }
      .store(in: &subscriptions)
  }
}

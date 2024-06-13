import Domain
import UIKit
import Combine

class StatementListViewModel: ViewModel {
  enum StatementListState: State {
    case loading, loaded([StatementsByDate]), error
  }
  enum StatementListEvent: Event {
    case load
  }
  enum StatementListAction: Action {}

  var stateSubject: CurrentValueSubject<StatementListState, Never> = .init(.loading)
  var actionSubject: PassthroughSubject<StatementListAction, Never> = .init()
  var subscriptions: Set<AnyCancellable> = []

  init(getStatementList: GetStatementList) {
    self.getStatementList = getStatementList

    sendEvent(.load)
  }

  private let getStatementList: GetStatementList

  func sendEvent(_ event: StatementListEvent) {
    switch event {
    case .load: onLoad()
    }
  }
}

extension StatementListViewModel {
  func onLoad() {
    stateSubject.send(.loading)
    getStatementList.execute(())
      .sink { [weak self] completion in
        if case .failure(_) = completion {
          self?.stateSubject.send(.error)
        }
      } receiveValue: { [weak self] statementsByDate in
        self?.stateSubject.send(.loaded(statementsByDate))
      }
      .store(in: &subscriptions)
  }
}


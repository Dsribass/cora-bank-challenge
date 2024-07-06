import Domain
import UIKit
import Combine

class StatementListViewModel: ViewModel {
  enum StatementListState: State {
    case loading, loaded([StatementsByDate]), error
  }
  enum StatementListEvent: Event {
    case load
    case filterBy(entry: StatementListView.MenuItem)
  }
  enum StatementListAction: Action {
    case updateStatements(filteredList: [StatementsByDate])
  }

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
    case .filterBy(let entry): onFilter(by: entry)
    }
  }
}

extension StatementListViewModel {
  func onFilter(by item: StatementListView.MenuItem) {
    if case .loaded(let statementsByDate) = stateSubject.value {
      let list: [StatementsByDate] = switch item {
        case .deposit:
          statementsByDate.map { (statements, date) in
            (statements.filter { $0.entry != .debit }, date)
          }
          .filter { !$0.statements.isEmpty }
        case .withdraw:
          statementsByDate.map { (statements, date) in
            (statements.filter { $0.entry != .credit }, date)
          }
          .filter { !$0.statements.isEmpty }
        case .all:
          statementsByDate
        case .forthcoming:
          []
      }

      actionSubject.send(.updateStatements(filteredList: list))
    }
  }

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


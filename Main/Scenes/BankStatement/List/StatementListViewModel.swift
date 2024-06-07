import Domain
import UIKit
import Combine

class StatementListViewModel: ViewModel {
  enum StatementListState: State {
    case inital
  }
  enum StatementListEvent: Event {}
  enum StatementListAction: Action {}

  var stateSubject: CurrentValueSubject<StatementListState, Never> = .init(.inital)
  var actionSubject: PassthroughSubject<StatementListAction, Never> = .init()
  var subscriptions: Set<AnyCancellable> = []

  func sendEvent(_ event: StatementListEvent) {}
}


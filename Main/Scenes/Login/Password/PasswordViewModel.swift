import Combine
import Domain

// MARK: - ViewModel
class PasswordViewModel: ViewModel {
  init(authenticate: AuthenticateUser) {
    self.authenticate = authenticate
  }

  private let authenticate: AuthenticateUser

  var stateSubject: CurrentValueSubject<PasswordState, Never> = .init(PasswordState())
  var actionSubject: PassthroughSubject<PasswordAction, Never> = .init()
  var subscriptions: Set<AnyCancellable> = .init()
  
  private var currentState: PasswordState { stateSubject.value }

  func sendEvent(_ event: PasswordEvent) {
    switch event {
    case .changePassword(let value): onChangePassword(value)
    case .submitPassword(let value): onSubmitPassword(value)
    }
  }

  func onChangePassword(_ value: String) {
    var updatedState = currentState
    updatedState.passwordValidation = .valid
    updatedState.shouldEnableSubmitButton = value.count >= 6
    stateSubject.send(updatedState)
  }

  // TODO(any): Implement this method
  func onSubmitPassword(_ value: String) {}
}

// MARK: - Events, States and Actions
extension PasswordViewModel {
  typealias A = PasswordAction
  typealias E = PasswordEvent
  typealias S = PasswordState

  enum PasswordAction: Action {}

  enum PasswordEvent: Event {
    case changePassword(value: String)
    case submitPassword(value: String)
  }

  struct PasswordState: State {
    init(
      shouldEnableSubmitButton: Bool = false,
      passwordValidation: FormValidation = .valid
    ) {
      self.shouldEnableSubmitButton = shouldEnableSubmitButton
      self.passwordValidation = passwordValidation
    }

    fileprivate(set) var shouldEnableSubmitButton: Bool
    fileprivate(set) var passwordValidation: FormValidation
  }
}

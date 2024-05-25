import Combine
import Domain

// MARK: - ViewModel
class PasswordViewModel: ViewModel {
  init(authenticate: AuthenticateUser, cpf: String) {
    self.authenticate = authenticate
    self.cpf = cpf
  }
  
  private let cpf: String
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

  func onSubmitPassword(_ value: String) {
    func handleFailure(_ error: DomainError) {
      var updatedState = currentState
      updatedState.passwordValidation = error == .notAuthorized ? .invalid : .error
      updatedState.shouldEnableSubmitButton = false
      updatedState.submitButtonIsLoading = false
      stateSubject.send(updatedState)
    }

    func handleSuccess() {}

    authenticate.execute(AuthenticateUser.Request(cpf: cpf, password: value))
      .sink { completion in
        switch completion {
        case .failure(let error): handleFailure(error)
        case .finished: break
        }
      } receiveValue: { handleSuccess() }
      .store(in: &subscriptions)
  }
}

// MARK: - Events, States and Actions
extension PasswordViewModel {
  typealias A = PasswordAction
  typealias E = PasswordEvent
  typealias S = PasswordState

  enum PasswordAction: Action {
    case signInSuccessfully
  }

  enum PasswordEvent: Event {
    case changePassword(value: String)
    case submitPassword(value: String)
  }

  struct PasswordState: State {
    init(
      shouldEnableSubmitButton: Bool = false,
      passwordValidation: FormValidation = .valid,
      submitButtonIsLoading: Bool = false
    ) {
      self.shouldEnableSubmitButton = shouldEnableSubmitButton
      self.passwordValidation = passwordValidation
      self.submitButtonIsLoading = submitButtonIsLoading
    }

    fileprivate(set) var shouldEnableSubmitButton: Bool
    fileprivate(set) var passwordValidation: FormValidation
    fileprivate(set) var submitButtonIsLoading: Bool
  }
}

import Foundation
import Domain
import Combine

class IdentificationViewModel: ViewModel {
  // MARK: - Initializer
  init(validateCpf: ValidateCpf) {
    self.validateCpf = validateCpf
  }

  private let validateCpf: ValidateCpf

  // MARK: - Publisher and Subscriptions
  private(set) var subscriptions: Set<AnyCancellable> = .init()
  private(set) var stateSubject: CurrentValueSubject<IdentificationState, Never> = .init(Idle())
  private(set) var actionSubject: PassthroughSubject<A, Never> = .init()

  private var currentState: IdentificationState { stateSubject.value }

  func sendEvent(_ event: IdentificationEvent) {
    switch event {
    case .submitCpfValue(let cpf): validateCpfInput(cpf)
    case .changeCpfValue(let cpf): formatCpf(cpf)
    }
  }

  func sendEvent(by publisher: () -> AnyPublisher<IdentificationEvent, Never>) {
    publisher().sink { [weak self] event in self?.sendEvent(event) }
      .store(in: &subscriptions)
  }

  func sendEvent(by publisher: AnyPublisher<IdentificationEvent, Never>) {
    publisher.sink { [weak self] event in self?.sendEvent(event) }
      .store(in: &subscriptions)
  }
}

// MARK: - Methods
extension IdentificationViewModel {
  private func validateCpfInput(_ value: String) {
    func handleFailure(_ error: ValidationError) {
      let newState = (currentState as! Idle).copyWith(
        cpfValidation: error == .empty ? .empty : .invalid,
        shouldEnableNextStepButton: false)

      stateSubject.send(newState)
    }

    func handleSuccess() {
      actionSubject.send(.goToNextStep)
    }

    validateCpf.execute(ValidateCpf.Request(cpf: value))
      .sink { completion in
        switch completion {
        case .failure(let error): handleFailure(error)
        case .finished: break
        }
      } receiveValue: { handleSuccess() }
      .store(in: &subscriptions)
  }

  private func formatCpf(_ value: String) {
    let dot = "."
    let hyphen = "-"
    let cleanedCpf = value.filter { $0.isNumber }
    var formattedCPF = ""
    for (index, char) in cleanedCpf.enumerated() {
      if index == 3 || index == 6 {
        formattedCPF.append(dot)
      } else if index == 9 {
        formattedCPF.append(hyphen)
      }
      formattedCPF.append(char)
    }

    stateSubject.send(
      (currentState as! Idle).copyWith(
        cpfValidation: .valid,
        shouldEnableNextStepButton: formattedCPF.count == cpfMaxLenght,
        cpfValue: formattedCPF
      )
    )
  }

  var cpfMaxLenght: Int { 14 }
}

// MARK: - Events, States and Actions
extension IdentificationViewModel {
  typealias S = IdentificationState
  typealias E = IdentificationEvent
  typealias A = IdentificationAction

  // MARK: - Action
  enum IdentificationAction: Action {
    case goToNextStep
  }

  // MARK: - Event
  enum IdentificationEvent: Event {
    case submitCpfValue(value: String), changeCpfValue(value: String)
  }

  // MARK: - State
  class IdentificationState: State {}

  class Idle: IdentificationState {
    init(cpfValidation: CpfValidation, shouldEnableNextStepButton: Bool, cpfValue: String) {
      self.cpfValidation = cpfValidation
      self.shouldEnableNextStepButton = shouldEnableNextStepButton
      self.cpfValue = cpfValue
    }

    convenience override init() {
      self.init(cpfValidation: .valid, shouldEnableNextStepButton: false, cpfValue: "")
    }

    enum CpfValidation {
      case invalid, valid, empty
    }

    let cpfValidation: CpfValidation
    let cpfValue: String
    let shouldEnableNextStepButton: Bool

    func copyWith(
      cpfValidation: CpfValidation? = nil,
      shouldEnableNextStepButton: Bool? = nil,
      cpfValue: String? = nil
    ) -> Idle {
      Idle(
        cpfValidation: cpfValidation ?? self.cpfValidation,
        shouldEnableNextStepButton: shouldEnableNextStepButton ?? self.shouldEnableNextStepButton,
        cpfValue: cpfValue ?? self.cpfValue
      )
    }
  }
}

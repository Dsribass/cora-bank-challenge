import Foundation
import Domain
import Combine

// MARK: - ViewModel
class IdentificationViewModel: ViewModel {
  typealias S = IdentificationState
  typealias E = IdentificationEvent
  typealias A = IdentificationAction

  init(validateCpf: ValidateCpf) {
    self.validateCpf = validateCpf
  }

  private let validateCpf: ValidateCpf

  private(set) var stateSubject: CurrentValueSubject<IdentificationState, Never> = .init(IdentificationState())
  private(set) var actionSubject: PassthroughSubject<A, Never> = .init()
  var subscriptions: Set<AnyCancellable> = .init()
  private var currentState: IdentificationState { stateSubject.value }

  func sendEvent(_ event: IdentificationEvent) {
    switch event {
    case .submitCpfValue(let cpf): onSubmitCpfValue(cpf)
    case .changeCpfValue(let cpf): onChangeCpfValue(cpf)
    }
  }

  private func onSubmitCpfValue(_ value: String) {
    let cleanedCPF = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

    func handleFailure(_ error: DomainError) {
      var updatedState = currentState
      switch error {
      case .inputEmpty:
        updatedState.cpfValidation = .empty
      case .inputInvalid:
        updatedState.cpfValidation = .invalid
      default:
        updatedState.cpfValidation = .invalid
      }
      updatedState.shouldEnableNextStepButton = false

      stateSubject.send(updatedState)
    }

    func handleSuccess() {
      actionSubject.send(.goToNextStep(cpf: cleanedCPF))
    }

    validateCpf.execute(ValidateCpf.Request(cpf: cleanedCPF))
      .sink { completion in
        switch completion {
        case .failure(let error): handleFailure(error)
        case .finished: break
        }
      } receiveValue: { handleSuccess() }
      .store(in: &subscriptions)
  }

  private func onChangeCpfValue(_ value: String) {
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

    var updatedState = currentState
    updatedState.cpfValidation = .valid
    updatedState.shouldEnableNextStepButton = formattedCPF.count == cpfMaxLenght
    updatedState.cpfValue = formattedCPF

    stateSubject.send(updatedState)
  }

  var cpfMaxLenght: Int { 14 }
}

// MARK: - Events, States and Actions
extension IdentificationViewModel {
  enum IdentificationAction: Action {
    case goToNextStep(cpf: String)
  }

  enum IdentificationEvent: Event {
    case submitCpfValue(value: String), changeCpfValue(value: String)
  }

  struct IdentificationState: State {
    init(
      cpfValidation: FormValidation = .valid,
      shouldEnableNextStepButton: Bool = false,
      cpfValue: String = ""
    ) {
      self.cpfValidation = cpfValidation
      self.shouldEnableNextStepButton = shouldEnableNextStepButton
      self.cpfValue = cpfValue
    }

    fileprivate(set) var cpfValidation: FormValidation
    fileprivate(set) var cpfValue: String
    fileprivate(set) var shouldEnableNextStepButton: Bool
  }
}

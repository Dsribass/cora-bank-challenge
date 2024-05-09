import Foundation
import Domain
import Combine

class IdentificationViewModel: ViewModel {
  // MARK: - Initializer
  init(validateCpf: ValidateCpfUseCase) {
    self.validateCpf = validateCpf
  }

  private let validateCpf: ValidateCpfUseCase

  // MARK: - Publisher and Subscriptions
  private(set) var subscriptions: Set<AnyCancellable> = .init()
  private(set) var stateSubject: CurrentValueSubject<IdentificationState, Never> = .init(Idle())

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

extension IdentificationViewModel {
  private func validateCpfInput(_ value: String) {
    func handleFailure(_ error: ValidationError) {
      let newState = (currentState as! Idle).copyWith(
        cpfValidation: error == .empty ? .empty : .invalid,
        shouldEnableNextStepButton: false)

      stateSubject.send(newState)
    }

    func handleSuccess() {
      let newState = (currentState as! Idle).copyWith(shouldEnableNextStepButton: true)
      stateSubject.send(newState)
    }

    validateCpf.execute(ValidateCpfUseCase.Request(cpf: value))
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

extension IdentificationViewModel {
  typealias S = IdentificationState
  typealias E = IdentificationEvent

  enum IdentificationEvent: Event {
    case submitCpfValue(value: String), changeCpfValue(value: String)
  }

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

import Foundation
import Domain
import Combine

class IdentificationViewModel: ViewModel {
  // MARK: - Initializer
  init(validateCpf: ValidateCpfUseCase) {
    self.validateCpf = validateCpf
  }

  private let validateCpf: ValidateCpfUseCase

  // MARK: - Event and States
  enum IdentificationEvent: Event {
    case submitCpfValue(value: String), changeCpfValue(value: String)
  }

  enum IdentificationState: State {
    case idle
    case cpfValid, cpfInvalid, cpfEmpty
    case cpfFormatted(value: String)
  }

  typealias S = IdentificationState
  typealias E = IdentificationEvent

  // MARK: - Publisher and Subscriptions
  private(set) var subscriptions: Set<AnyCancellable> = .init()
  private(set) var stateSubject: CurrentValueSubject<IdentificationState, Never> = .init(.idle)

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
    validateCpf.execute(ValidateCpfUseCase.Request(cpf: value))
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.stateSubject.send(error == .empty ? .cpfEmpty : .cpfInvalid)
        case.finished: break
        }
      } receiveValue: { [weak self] _ in
        self?.stateSubject.send(.cpfValid)
      }
      .store(in: &subscriptions)
  }

  private func formatCpf(_ value: String) {
    var appendString = ""

    if value.count <= 14 {
      switch value.count {
      case 3, 7:
        appendString = "."
      case 11:
        appendString = "-"
      default:
        break
      }
    }

    stateSubject.send(.cpfFormatted(value: value.appending(appendString)))
  }
}

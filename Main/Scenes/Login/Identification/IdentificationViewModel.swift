import Foundation
import Domain
import Combine

class IdentificationViewModel {
  enum Event {
    case submitCpfValue(value: String), changeCpfValue(value: String)
  }

  enum State {
    case cpfValid, cpfInvalid, cpfEmpty
    case cpfFormatted(value: String)
  }

  init(validateCpf: ValidateCpfUseCase) {
    self.validateCpf = validateCpf
  }


  private let validateCpf: ValidateCpfUseCase
  private let stateSubject = PassthroughSubject<State, Never>()
  private var subscriptions = Set<AnyCancellable>()

  var state: AnyPublisher<State, Never> { stateSubject.eraseToAnyPublisher() }

  func sendEvent(_ publisher: () -> AnyPublisher<Event, Never>) {
    publisher().sink { [weak self] event in
      switch event {
      case .submitCpfValue(let cpf): self?.validateCpfInput(cpf)
      case .changeCpfValue(let cpf): self?.formatCpf(cpf)
      }
    }
    .store(in: &subscriptions)
  }

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

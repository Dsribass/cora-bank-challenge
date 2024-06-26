import UIKit
import Combine

class IdentificationViewController: SceneViewController<IdentificationView> {
  init(viewModel: IdentificationViewModel, router: IdentificationViewRouter) {
    self.viewModel = viewModel
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  private let viewModel: IdentificationViewModel
  private let router: IdentificationViewRouter

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupLayout() {
    super.setupLayout()
    title = Strings.Login.navBarTitle
  }

  override func additionalConfigurations() {
    hideKeyboardWhenTappedAround()
    contentView.textField.becomeFirstResponder()
    contentView.textField.delegate = self
  }

  override func setupBindings() {
    func bindViewToViewModel() {
      contentView.nextStepButton.publisher(for: .touchUpInside).map { [weak contentView] _ in
        contentView?.textField.text ?? ""
      }
      .map { .submitCpfValue(value: $0) }
      .eraseToAnyPublisher()
      .sendEvent(to: viewModel)

      contentView.textField.textPublisher(for: UITextField.textDidChangeNotification)
        .map {.changeCpfValue(value: $0) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)
    }

    func bindViewModelToView() {
      listenState(
        of: viewModel.stateSubject.eraseToAnyPublisher()
      ) { [weak contentView] state in
        contentView?.nextStepButton.isEnabled = state.shouldEnableNextStepButton
        contentView?.textField.text = state.cpfValue
        contentView?.textFieldErrorMessage.isHidden = state.cpfValidation == .valid
        contentView?.textFieldErrorMessage.text = switch state.cpfValidation {
        case .empty: Strings.Identification.cpfEmpty
        case .invalid: Strings.Identification.cpfInvalid
        default: ""
        }
      }
      .store(in: &bindings)

      listenAction(of: viewModel.actionSubject.eraseToAnyPublisher()) { [weak self] action in
        switch action {
        case .goToNextStep(let cpf):
          self?.router.navigateToPasswordView(cpf: cpf)
        }
      }
      .store(in: &bindings)
    }

    bindViewToViewModel()
    bindViewModelToView()
  }
}

extension IdentificationViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (textField.text?.count)! == viewModel.cpfMaxLenght && range.length == 0 {
      return false
    }
    return true
  }
}

protocol IdentificationViewRouter {
  func navigateToPasswordView(cpf: String)
}

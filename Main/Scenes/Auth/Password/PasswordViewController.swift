import UIKit

class PasswordViewController: SceneViewController<PasswordView> {
  init(viewModel: PasswordViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  private let viewModel: PasswordViewModel

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.Login.navBarTitle
  }

  override func setupBindings() {
    func bindViewToViewModel() {
      contentView.textField
        .textPublisher(for: UITextField.textDidChangeNotification)
        .map { .changePassword(value: $0) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)

      contentView.nextStepButton.publisher(for: .touchUpInside)
        .map { [weak contentView] _ in
          contentView?.textField.text ?? ""
        }
        .map { .submitPassword(value: $0) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)
    }

    func bindViewModelToView() {
      listenState(of: viewModel.stateSubject.eraseToAnyPublisher())
      { [weak contentView] state in
        guard let view = contentView else {
          return
        }

        view.nextStepButton.isEnabled = state.shouldEnableSubmitButton
        view.textFieldErrorMessage.isHidden = state.passwordValidation == .valid

        view.textFieldErrorMessage.text = switch state.passwordValidation {
          case .invalid: Strings.Password.invalid
          case .error: Strings.Password.error
          default: ""
        }

        if state.submitButtonIsLoading {
          contentView?.nextStepButton.showLoading()
          view.nextStepButton.isEnabled = false
        } else {
          contentView?.nextStepButton.stopLoading()
        }
      }
      .store(in: &bindings)
    }

    (contentView.textField.rightView as? UIButton)?.publisher(for: .touchUpInside)
      .sink { [weak contentView] _ in
        contentView?.textField.isSecureTextEntry.toggle()
      }
      .store(in: &bindings)

    bindViewToViewModel()
    bindViewModelToView()
  }

  override func additionalConfigurations() {
    hideKeyboardWhenTappedAround()
    contentView.textField.becomeFirstResponder()
  }
}

import UIKit
import Combine

class IdentificationViewController: SceneViewController<IdentificationView> {
  typealias VM =  IdentificationViewModel
  let viewModel: IdentificationViewModel

  init(viewModel: IdentificationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupLayout() {
    super.setupLayout()
    title = LocalizedStrings.loginNavBarTitle
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
      .map { cpf -> VM.E in .submitCpfValue(value: cpf) }
      .eraseToAnyPublisher()
      .sendEvent(to: viewModel)

      contentView.textField.textPublisher(for: UITextField.textDidChangeNotification)
        .map { cpf -> VM.E in .changeCpfValue(value: cpf) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)
    }

    func bindViewModelToView() {
      updateUI(
        with: viewModel.stateSubject.eraseToAnyPublisher()
      ) { [weak contentView] state in
        if state is VM.Idle {
          let idle = state as! VM.Idle

          contentView?.nextStepButton.isEnabled = idle.shouldEnableNextStepButton
          contentView?.textField.text = idle.cpfValue
          contentView?.textFieldErrorMessage.isHidden = idle.cpfValidation == .valid
          contentView?.textFieldErrorMessage.text = switch idle.cpfValidation {
          case .empty: LocalizedStrings.identificationCpfEmpty
          case .invalid: LocalizedStrings.identificationCpfInvalid
          default: ""
          }
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

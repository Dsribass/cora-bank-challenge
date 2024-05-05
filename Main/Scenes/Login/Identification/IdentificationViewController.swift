import UIKit
import Combine

class IdentificationViewController: SceneViewController<IdentificationView> {
  let viewModel: IdentificationViewModel

  init(viewModel: IdentificationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupBindings() {
    func bindViewToViewModel() {
      contentView.textField.textPublisher(for: UITextField.textDidEndEditingNotification)
        .map { cpf -> IdentificationViewModel.E in .submitCpfValue(value: cpf) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)

      contentView.textField.textPublisher(for: UITextField.textDidChangeNotification)
        .map { cpf -> IdentificationViewModel.E in .changeCpfValue(value: cpf) }
        .eraseToAnyPublisher()
        .sendEvent(to: viewModel)
    }

    func bindViewModelToView() {
      viewModel.stateSubject.receive(on: DispatchQueue.main)
        .sink { [weak contentView] state in
          switch state {
          case .cpfFormatted(let value):
            contentView?.textField.text = value
          default: break
          }
        }
        .store(in: &bindings)
    }

    bindViewToViewModel()
    bindViewModelToView()
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
}

extension IdentificationViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (textField.text?.count)! > 13 && range.length == 0 {
      return false
    }
    return true
  }
}

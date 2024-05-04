import UIKit
import Combine

class IdentificationViewController: SceneViewController<IdentificationView> {
  let viewModel: IdentificationViewModel
  var subscriptions = Set<AnyCancellable>()

  init(viewModel: IdentificationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
  }

  func setupBindings() {
    func bindViewToViewModel() {
      viewModel.sendEvent {
        contentView.textField.textPublisher(for: UITextField.textDidEndEditingNotification)
          .map { cpf ->  IdentificationViewModel.Event in
            .submitCpfValue(value: cpf)
          }.eraseToAnyPublisher()
      }

      viewModel.sendEvent {
        contentView.textField.textPublisher(for: UITextField.textDidChangeNotification)
          .map { cpf ->  IdentificationViewModel.Event in
            .changeCpfValue(value: cpf)
          }.eraseToAnyPublisher()
      }
    }

    func bindViewModelToView() {
      viewModel.state.receive(on: DispatchQueue.main)
        .sink { [weak contentView] state in
          switch state {
          case .cpfFormatted(let value):
            contentView?.textField.text = value
          default: break
          }
        }
        .store(in: &subscriptions)
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

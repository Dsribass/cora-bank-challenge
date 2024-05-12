import UIKit

class PasswordViewController: SceneViewController<PasswordView> {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = LocalizedStrings.loginNavBarTitle
  }

  override func setupBindings() {
    (contentView.textField.rightView as? UIButton)?.publisher(for: .touchUpInside)
      .sink { [weak contentView] _ in
        contentView?.textField.isSecureTextEntry.toggle()
      }
      .store(in: &bindings)
  }

  override func additionalConfigurations() {
    hideKeyboardWhenTappedAround()
    contentView.textField.becomeFirstResponder()
  }
}

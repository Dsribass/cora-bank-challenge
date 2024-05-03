import UIKit

class IdentificationViewController: SceneViewController<IdentificationView> {
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
  }

  override func setupLayout() {
    super.setupLayout()
    title = LocalizedStrings.loginNavBarTitle
  }

  override func additionalConfigurations() {
    contentView.textField.becomeFirstResponder()
    contentView.textField.delegate = self
  }
}

extension IdentificationViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    var appendString = ""

    if range.length == 0 {
      switch range.location {
      case 3, 7:
        appendString = "."
      case 11:
        appendString = "-"
      default:
        break
      }
    }

    textField.text?.append(appendString)

    if (textField.text?.count)! > 13 && range.length == 0 {
      return false
    }
    return true
  }
}

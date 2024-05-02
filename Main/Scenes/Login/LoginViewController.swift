import UIKit

class LoginViewController: SceneViewController<LoginView> {
  override func setupLayout() {
    super.setupLayout()
    title = LocalizedStrings.loginNavBarTitle
  }
}

import UIKit

class LoginCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.pushViewController(LoginViewController(), animated: true)
  }
}

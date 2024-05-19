import UIKit
import Domain

class LoginCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.pushViewController(
      Factory.ViewController.makeIdentificationVC(router: self),
      animated: true)
  }
}

extension LoginCoordinator: IdentificationViewRouter, PasswordViewRouter {
  func navigateToPasswordView(cpf: String) {
    navigationController.pushViewController(
      Factory.ViewController.makePasswordVC(cpf: cpf, router: self),
      animated: true)
  }

  func navigateToInitialPage() {
    navigationController.setViewControllers(
      [BankStatementViewController()],
      animated: true)
  }
}

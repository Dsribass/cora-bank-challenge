import UIKit
import Domain

class AuthCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.pushViewController(
      Factory.ViewController.makeIntroVC(router: self),
      animated: true)
  }
}

extension AuthCoordinator: IntroViewRouter, IdentificationViewRouter {
  func navigateToIdentificationView() {
    navigationController.pushViewController(
      Factory.ViewController.makeIdentificationVC(router: self),
      animated: true)
  }

  func navigateToPasswordView(cpf: String) {
    navigationController.pushViewController(
      Factory.ViewController.makePasswordVC(cpf: cpf),
      animated: true)
  }
}

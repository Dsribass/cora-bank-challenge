import UIKit

class IntroCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.setViewControllers([
      Factory.ViewController.makeIntroVC(router: self)
    ], animated: false)
  }
}

extension IntroCoordinator: IntroViewRouter {
  func navigateToLoginView() {
    let coordinator = LoginCoordinator(nav: navigationController)
    coordinator.start()
  }
}

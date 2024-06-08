import UIKit
import Domain

class BankStatementCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.setViewControllers(
      [Factory.ViewController.makeStatementListVC(
        router: self
      )],
      animated: true)
  }
}

extension BankStatementCoordinator: StatementListRouter {
  func navigateToDetails(id: String) {
    navigationController.pushViewController(
      StatementDetailViewController(id: id),
      animated: true)
  }
}


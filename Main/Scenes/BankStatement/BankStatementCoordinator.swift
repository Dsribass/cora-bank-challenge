import UIKit
import Domain

class BankStatementCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.pushViewController(
      StatementListViewController(),
      animated: true)
  }
}


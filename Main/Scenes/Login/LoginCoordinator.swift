import UIKit
import Domain

class LoginCoordinator: Coordinator {
  var navigationController: UINavigationController

  init(nav: UINavigationController) {
    self.navigationController = nav
  }

  func start() {
    navigationController.pushViewController(IdentificationViewController(
      viewModel: IdentificationViewModel(validateCpf: ValidateCpfUseCase())
    ), animated: true)
  }
}

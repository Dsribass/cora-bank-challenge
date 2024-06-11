import UIKit
import Infra

final class IntroViewController: SceneViewController<IntroView> {
  init(router: IntroViewRouter) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  let router: IntroViewRouter

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    contentView.secondaryButton.handleButtonTap { [unowned self] _ in
      self.router.navigateToIdentificationView()
    }
  }

  override func setupLayout() {
    super.setupLayout()
  }
}

protocol IntroViewRouter {
  func navigateToIdentificationView()
}

import UIKit
import Infra

final class IntroViewController: SceneViewController<IntroView> {
  init(router: IntroViewRouter) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
      self.router.navigateToLoginView()
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
  }
}

protocol IntroViewRouter {
  func navigateToLoginView()
}

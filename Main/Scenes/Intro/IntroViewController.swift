import UIKit

final class IntroViewController: SceneViewController<IntroView> {
  init(router: IntroViewRouter) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let router: IntroViewRouter

  override func viewDidLoad() {
    super.viewDidLoad()

    contentView.secondaryButton.handleButtonTap { [unowned self] _ in
      self.router.navigateToLoginView()
    }
  }

  override func setupLayout() {
    super.setupLayout()
    navigationController?.navigationBar.isHidden = true
  }
}

protocol IntroViewRouter {
  func navigateToLoginView()
}

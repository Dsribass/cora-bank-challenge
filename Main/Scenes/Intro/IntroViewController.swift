import UIKit

final class IntroViewController: SceneViewController<IntroView> {
  override func setupLayout() {
    super.setupLayout()
    navigationController?.navigationBar.isHidden = true
  }
}

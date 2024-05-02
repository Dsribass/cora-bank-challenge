import UIKit

class SceneViewController<View: UIView>: UIViewController, ViewCodable {
  var contentView: View { view as! View }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.backButtonDisplayMode = .minimal
    setupView()
  }

  override func loadView() {
    self.view = View()
  }

  func setupLayout() {}

  func setupSubviews() {}

  func setupConstraints() {}

  func additionalConfigurations() {}
}

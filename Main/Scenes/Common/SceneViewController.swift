import UIKit

class SceneViewController<View: UIView>: UIViewController, ViewCodable {
  var contentView: View { view as! View }

  override func viewDidLoad() {
    super.viewDidLoad()
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

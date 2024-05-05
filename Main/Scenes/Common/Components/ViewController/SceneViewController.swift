import UIKit
import Combine

class SceneViewController<View: UIView>: UIViewController, ViewCodable {
  var contentView: View { view as! View }
  var bindings = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.backButtonDisplayMode = .minimal
    setupView()
    setupBindings()
  }
  
  override func loadView() {
    self.view = View()
  }

  func setupBindings() {}

  func setupLayout() {}
  
  func setupSubviews() {}
  
  func setupConstraints() {}
  
  func additionalConfigurations() {}
}


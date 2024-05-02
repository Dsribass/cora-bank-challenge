import UIKit

class UIViewCodable: UIView, ViewCodable {
  convenience init() {
    self.init(frame: .zero)
    setupView()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder:coder)
    setupView()
  }

  func setupLayout() {}

  func setupSubviews() {}

  func setupConstraints() {}

  func additionalConfigurations() {}
}

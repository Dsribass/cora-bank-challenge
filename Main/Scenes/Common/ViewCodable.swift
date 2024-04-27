import UIKit

protocol ViewCodable {
  func setupView()
  func setupLayout()
  func setupSubviews()
  func setupConstraints()
  func additionalConfigurations()
}

extension ViewCodable {
  func setupView()  {
    setupLayout()
    setupSubviews()
    setupConstraints()
    additionalConfigurations()
  }
}

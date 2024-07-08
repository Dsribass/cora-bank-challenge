import UIKit

/// A protocol that defines the methods for setting up a view.
protocol ViewCodable {
  /// Method to set up the entire view, including layout, subviews, constraints, and additional configurations.
  func setupView()
  
  /// Method to set up the layout of the view.
  func setupLayout()
  
  /// Method to add subviews to the view.
  func setupSubviews()
  
  /// Method to set up the constraints for the subviews.
  func setupConstraints()
  
  /// Method to apply additional configurations to the view.
  func additionalConfigurations()
}

extension ViewCodable {
  /// Default implementation of `setupView` method that calls the other setup methods in the required order.
  func setupView() {
    setupLayout()
    setupSubviews()
    setupConstraints()
    additionalConfigurations()
  }
}

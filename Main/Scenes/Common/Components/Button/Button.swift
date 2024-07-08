import UIKit.UIButton

/// The `CoraButton` class is designed to be used for creating custom buttons with a consistent design style.
///
/// The button's visual appearance can be customized by setting the `size`, `variation`, and `color` properties, which are defined as enums:
/// - `Size`: The size of the button, which can be `.small`, `.medium`, or `.large`.
/// - `Variation`: The variation style of the button, which can be `.primary` or `.secondary`.
/// - `Color`: The color theme of the button, which can be `.brand` or `.white`.
///
/// You can handle button taps by calling the `handleButtonTap(:)` method with a completion block.
/// Additionally, you can show and hide a loading indicator by calling the `showLoading()` and `stopLoading()` methods, respectively.
///
/// ## Example Usage
/// ```swift
/// // Define a custom button instance
/// let customButton = CoraButton(
///     title: "Click Me",
///     size: .medium,
///     variation: .primary,
///     color: .brand,
///     image: UIImage(named: "exampleIcon")
/// )
///
/// customButton.handleButtonTap { action in
///     print("Button tapped!")
/// }
///
/// // Show loading indicator
/// customButton.showLoading()
///
/// // Stop loading indicator
/// customButton.stopLoading()
/// ```
class CoraButton: UIButton {
  init(title: String, size: Size, variation: Variation, color: Color, image: UIImage? = nil) {
    self.title = title
    self.size = size
    self.variation = variation
    self.color = color
    self.image = image
    super.init(frame: .zero)
    configuration = .filled()
    contentHorizontalAlignment = .fill
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let title: String
  var size: Size
  var variation: Variation
  var color: Color
  var image: UIImage?

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.color = .Cora.gray1
    return activityIndicator
  }()

  func handleButtonTap(_ completion: @escaping UIActionHandler) {
    addAction(UIAction(title: "", handler: completion), for: .touchUpInside)
  }

  override func updateConfiguration() {
    guard let configuration = configuration else {
      return
    }

    var updatedConfiguration = configuration
    updatedConfiguration.title = title
    updatedConfiguration.contentInsets =
      .init(
        top: size.insets().vertical,
        leading: size.insets().horizontal,
        bottom: size.insets().vertical,
        trailing: size.insets().horizontal)

    updatedConfiguration.titleTextAttributesTransformer = configureTextAttributes()

    if variation == .primary {
      updatedConfiguration.background = UIButton.Configuration.tinted().background
      switch color {
      case .brand:
        updatedConfiguration.baseBackgroundColor = .Cora.primaryColor
        updatedConfiguration.baseForegroundColor = .Cora.white
      case .white:
        updatedConfiguration.baseBackgroundColor = .Cora.white
        updatedConfiguration.baseForegroundColor = .Cora.primaryColor
      }
    } else {
      updatedConfiguration.background = UIButton.Configuration.bordered().background
      updatedConfiguration.background.strokeWidth = 1
      switch color {
      case .brand:
        updatedConfiguration.baseBackgroundColor = .clear
        updatedConfiguration.baseForegroundColor = .Cora.primaryColor
        updatedConfiguration.background.strokeColor = .Cora.primaryColor
      case .white:
        updatedConfiguration.baseBackgroundColor = .clear
        updatedConfiguration.baseForegroundColor = .Cora.white
        updatedConfiguration.background.strokeColor = .Cora.white
      }
    }

    updatedConfiguration.background.cornerRadius = size.cornerRadius()
    updatedConfiguration.image = image?.withTintColor(updatedConfiguration.baseForegroundColor!)
    updatedConfiguration.imagePlacement = .trailing

    self.configuration = updatedConfiguration
  }

  private func configureTextAttributes() -> UIConfigurationTextAttributesTransformer {
    UIConfigurationTextAttributesTransformer { [weak self] attributes in
      guard let self = self else { return attributes }

      var updatedAttributes = attributes
      updatedAttributes.font = UIFont.coraFont(
        for: self.size.font(),
        weight: .bold)


      return updatedAttributes
    }
  }
}

extension CoraButton {
  func stopLoading() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
    imageView?.alpha = 1
  }

  func showLoading() {
    imageView?.alpha = 0
    addSubview(activityIndicator)
    setupConstraint(activityIndicator)
    activityIndicator.startAnimating()
  }

  private func setupConstraint(_ activityIndicator: UIActivityIndicatorView) {
    activityIndicator.makeConstraints {[
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -size.insets().horizontal),
      $0.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]}
  }
}

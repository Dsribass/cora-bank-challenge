import UIKit.UIButton

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
        updatedConfiguration.baseForegroundColor = .Cora.onPrimaryColor
      case .white:
        updatedConfiguration.baseBackgroundColor = .Cora.onPrimaryColor
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
        updatedConfiguration.baseForegroundColor = .Cora.onPrimaryColor
        updatedConfiguration.background.strokeColor = .Cora.onPrimaryColor
      }
    }

    updatedConfiguration.background.cornerRadius = size.cornerRadius()
    updatedConfiguration.image = image
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

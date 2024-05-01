import UIKit.UIButton

class CoraButton: UIButton {
  init(title: String, size: Size, variation: Variation, color: Color, image: UIImage? = nil) {
    self.title = title
    self.size = size
    self.variation = variation
    self.color = color
    self.image = image
    super.init(frame: .zero)
    configuration = .plain()
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
    updatedConfiguration.background = configureBackground()
    updatedConfiguration.baseForegroundColor = color.foreground()
    updatedConfiguration.image = image
    updatedConfiguration.imagePlacement = .trailing

    self.configuration = updatedConfiguration
  }

  private func configureBackground() -> UIBackgroundConfiguration {
    var background = UIButton.Configuration.plain().background
    background.cornerRadius = size.cornerRadius()

    if variation == .secondary {
      background.strokeWidth = 1
      background.strokeColor = color.background()
      background.backgroundColor = .clear
    } else {
      background.backgroundColor = color.background()
    }

    return background
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
  enum Size {
    case small, medium, large

    func cornerRadius() -> Double {
      switch self {
      case .small: 12
      case .medium: 16
      case .large: 22
      }
    }

    func insets() -> (horizontal: Double, vertical: Double) {
      switch self {
      case .small: (24, 14)
      case .medium: (24, 20)
      case .large: (32, 20)
      }
    }

    func font() -> CoraFont {
      switch self {
      case .small: .body2
      case .medium: .body1
      case .large: .title2
      }
    }
  }

  enum Variation {
    case primary, secondary
  }

  enum Color {
    case brand, white

    func background() -> UIColor {
      switch self {
      case .brand: .Cora.primaryColor
      case .white: .white
      }
    }

    func foreground() -> UIColor {
      switch self {
      case .brand: .white
      case .white: .Cora.primaryColor
      }
    }
  }
}

import UIKit.UIFont

enum CoraFont {
  case title1, title2
  case body1, body2

  static let fontName = "Avenir"

  fileprivate func buildFontName(weight: Weight) -> String { "\(CoraFont.fontName)-\(weight.rawValue)" }

  fileprivate func buildFont(weight: Weight) -> UIFont? {
    switch self {
    case .title1: UIFont(name: buildFontName(weight: weight), size: 28.0)
    case .title2: UIFont(name: buildFontName(weight: weight), size: 22.0)
    case .body1: UIFont(name: buildFontName(weight: weight), size: 16.0)
    case .body2: UIFont(name: buildFontName(weight: weight), size: 14.0)
    }
  }
}

extension CoraFont {
  enum Weight: String {
    case regular = "Roman", bold = "Heavy"
  }
}

extension UIFont {

  /// A convenience method to retrieve a custom font for a specific style and weight.
  ///
  /// This method allows easy access to custom fonts defined in the CoraFont enum, providing support for different font styles and weights.
  ///
  /// - Parameters:
  ///   - style: The style of the font, represented by a case of the CoraFont enum.
  ///   - weight: The weight of the font, represented by a case of the CoraFont.Weight enum.
  /// - Returns: A UIFont instance representing the custom font for the specified style and weight. If the specified font is not found, a system font with regular weight and the default system font size is returned.
  ///
  /// - Note: Ensure that the custom fonts are correctly configured and included in the project.
  static func coraFont(for style: CoraFont, weight: CoraFont.Weight) -> UIFont {
    style.buildFont(weight: weight) ?? UIFont.systemFont(ofSize: systemFontSize, weight: .regular)
  }
}

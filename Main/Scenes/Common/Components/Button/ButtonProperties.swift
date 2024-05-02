import UIKit

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
  }
}


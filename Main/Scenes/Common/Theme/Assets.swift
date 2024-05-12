import UIKit.UIImage

extension UIImage {
  enum CoraImages: String {
    case logo = "logo"
    case introBg = "intro-bg"
    case icArrowRight = "arrow.right"
    case icChevronLeft = "chevron.left"
    case icEyeHidden = "eye.hidden"
  }
  
  convenience init?(named: CoraImages) {
    self.init(named: named.rawValue)
  }
}

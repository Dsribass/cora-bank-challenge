import UIKit.UIImage

extension UIImage {
  enum CoraImages: String {
    case logo = "logo"
    case introBg = "intro-bg"
    case icArrowRight = "arrow.right"
    case icChevronLeft = "chevron.left"
    case icEyeHidden = "eye.hidden"
    case icArrowDownIn = "arrow.down.in"
    case icArrowUpOut = "arrow.up.out"
    case icArrowReturn = "arrow.return"
    case icBarcode = "barcode"
    case icPercentage = "percentage"
    case icShare = "share"
    case icSignOut = "sign.out"

  }
  
  convenience init?(named: CoraImages) {
    self.init(named: named.rawValue)
  }
}

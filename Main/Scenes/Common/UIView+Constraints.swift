import UIKit

extension UIView {
  func makeConstraints(_ completion: (UIView) -> [NSLayoutConstraint]) {
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(completion(self))
  }
}

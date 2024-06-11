import UIKit

// MARK: - UIColors
extension UIColor {
    func darker() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }

        return UIColor()
    }
}

// MARK: - UIView
extension UIView {
  func makeConstraints(_ completion: (UIView) -> [NSLayoutConstraint]) {
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(completion(self))
  }
}

// MARK: - UIViewController

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Formatters
extension Double {
  func convertToCurrencyFormat() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: NSNumber(value: self))
  }
}

extension Int {
  func convertToCurrencyFormat() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: NSNumber(value: self))
  }
}

extension Date {
  func hourMinuteFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: self)
  }

  func weekdayAndMonth() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE - d 'de' MMMM"
    return dateFormatter.string(from: self)
  }

  func weekdayAndFullDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE - dd/MM/yyyy"
    return dateFormatter.string(from: self)
  }
}

import Foundation

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

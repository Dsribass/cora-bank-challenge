import UIKit
import Combine

extension UITextField {
  func textPublisher(for event: NSNotification.Name) -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: event, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}

import Combine
import UIKit

extension UITextField {
  func textPublisher(for event: NSNotification.Name) -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: event, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output: Event, Failure == Never {
    func sendEvent<V: ViewModel>(to viewModel: V) where V.E == Output {
        viewModel.sendEvent(by: self)
    }
}

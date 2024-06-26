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

// https://www.swiftbysundell.com/articles/building-custom-combine-publishers-in-swift/
private extension UIControl {
    class EventSubscription<Target: Subscriber>: Subscription
        where Target.Input == Void {

        var target: Target?

        // This subscription doesn't respond to demand, since it'll
        // simply emit events according to its underlying UIControl
        // instance, but we still have to implement this method
        // in order to conform to the Subscription protocol:
        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            // When our subscription was cancelled, we'll release
            // the reference to our target to prevent any
            // additional events from being sent to it:
            target = nil
        }

        @objc func trigger() {
            // Whenever an event was triggered by the underlying
            // UIControl instance, we'll simply pass Void to our
            // target to emit that event:
            var _ = target?.receive(())
        }
    }
}

extension UIControl {
    struct EventPublisher: Publisher {
        // Declaring that our publisher doesn't emit any values,
        // and that it can never fail:
        typealias Output = Void
        typealias Failure = Never

        fileprivate var control: UIControl
        fileprivate var event: Event

        // Combine will call this method on our publisher whenever
        // a new object started observing it. Within this method,
        // we'll need to create a subscription instance and
        // attach it to the new subscriber:
        func receive<S: Subscriber>(
            subscriber: S
        ) where S.Input == Output, S.Failure == Failure {
            // Creating our custom subscription instance:
            let subscription = EventSubscription<S>()
            subscription.target = subscriber

            // Attaching our subscription to the subscriber:
            subscriber.receive(subscription: subscription)

            // Connecting our subscription to the control that's
            // being observed:
            control.addTarget(subscription,
                action: #selector(subscription.trigger),
                for: event
            )
        }
    }
}

extension UIControl {
    func publisher(for event: Event) -> EventPublisher {
        EventPublisher(
            control: self,
            event: event
        )
    }
}

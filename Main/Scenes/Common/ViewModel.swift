import Combine
import Foundation

/// A protocol representing an event in a view model.
/// Implement this protocol to add custom events to your view model.
protocol Event {}

/// A protocol representing the state of a view model.
/// Implement this protocol to add custom states to your view model.
protocol State {}

/// A protocol representing an action triggered by the view model.
/// Implement this protocol to add custom actions to your view model.
protocol Action {}

/// A protocol representing a view model, which mediates between the view and the model(s), handling user inputs and updating the UI.
///
/// View models encapsulate the presentation logic of your application. They manage the state of the UI and handle user interactions, abstracting away the details of data manipulation and business logic.
protocol ViewModel: AnyObject {
  /// The associated type representing the state of the view model.
  associatedtype S: State

  /// The associated type representing the events that can be handled by the view model.
  associatedtype E: Event

  /// The associated type representing the actions that can be triggered by the view model.
  associatedtype A: Action

  /// A subject that publishes the current state of the view model.
  ///
  /// Subscribe to this subject to receive updates about changes in the state of the view model. Use the published state to update the UI accordingly.
  var stateSubject: CurrentValueSubject<S, Never> { get }

  /// A subject that emits actions to trigger state updates in the view model.
  ///
  /// Subscribe to this subject to receive actions that represent user interactions or other events. Use these actions to update the state of the view model, which in turn may trigger updates to the UI.
  var actionSubject: PassthroughSubject<A, Never> { get }

  /// A set to keep track of subscriptions to Combine publishers.
  ///
  /// Add subscriptions to this set to manage the lifecycle of Combine publishers used within the view model. Ensure to cancel these subscriptions when they are no longer needed to prevent memory leaks.
  var subscriptions: Set<AnyCancellable> { get set }

  /// Sends the given event to the view model for handling.
  ///
  /// - Parameter event: The event to be handled by the view model.
  ///
  /// Call this method to trigger actions in the view model based on user interactions or other external events. Implement this method to define the behavior in response to different events.
  func sendEvent(_ event: E)

  /// Sends events emitted by the provided publisher to the view model for handling.
  ///
  /// - Parameter publisher: A closure that returns a publisher emitting events to be handled by the view model.
  ///
  /// Use this method to listen for events emitted by a Combine publisher and handle them within the view model. Pass a closure that returns a publisher emitting events of the associated event type (`E`) to subscribe to events from external sources.
  func sendEvent(by publisher: () -> AnyPublisher<E, Never>)

  /// Sends events emitted by the provided publisher to the view model for handling.
  ///
  /// - Parameter publisher: A publisher emitting events to be handled by the view model.
  ///
  /// Use this method to listen for events emitted by a Combine publisher and handle them within the view model. Subscribe directly to a publisher emitting events of the associated event type (`E`) to handle events from external sources.
  func sendEvent(by publisher: AnyPublisher<E, Never>)
}

extension ViewModel {
  func sendEvent(by publisher: () -> AnyPublisher<E, Never>) {
    publisher().sink { [weak self] event in self?.sendEvent(event) }
      .store(in: &subscriptions)
  }

  func sendEvent(by publisher: AnyPublisher<E, Never>) {
    publisher.sink { [weak self] event in self?.sendEvent(event) }
      .store(in: &subscriptions)
  }
}

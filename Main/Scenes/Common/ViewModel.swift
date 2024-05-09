import Combine
import Foundation

/// A protocol representing an event in a view model.
/// Implement this protocol to add custom events to your view model.
protocol Event {}

/// A protocol representing the state of a view model.
/// Implement this protocol to add custom states to your view model.
protocol State {}

/// A protocol representing a view model, which mediates between the view and the model(s), handling user inputs and updating the UI.
///
/// View models encapsulate the presentation logic of your application. They manage the state of the UI and handle user interactions, abstracting away the details of data manipulation and business logic.
protocol ViewModel {
  /// The associated type representing the state of the view model.
  associatedtype S: State

  /// The associated type representing the events that can be handled by the view model.
  associatedtype E: Event

  /// A subject that publishes the current state of the view model.
  ///
  /// Subscribe to this subject to receive updates about changes in the state of the view model. Use the published state to update the UI accordingly.
  var stateSubject: CurrentValueSubject<S, Never> { get }

  /// A set to keep track of subscriptions to Combine publishers.
  ///
  /// Add subscriptions to this set to manage the lifecycle of Combine publishers used within the view model. Ensure to cancel these subscriptions when they are no longer needed to prevent memory leaks.
  var subscriptions: Set<AnyCancellable> { get }

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

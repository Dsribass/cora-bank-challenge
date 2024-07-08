import UIKit

/// The `Coordinator` protocol is a protocol that can be adopted by any class that wants to act as a coordinator.
/// It can be a top-level coordinator that manages the navigation of the app, or a child coordinator that manages the navigation of a particular feature or module.
///
/// This protocol defines the basic structure of a coordinator.
/// A coordinator is an object that is responsible for the navigation flow of the app.
/// It is responsible for creating and presenting view controllers, handling navigation, and managing the flow of the app.
///
/// The `start` method is the entry point of the coordinator.
/// This is where the coordinator should create and present the initial view controller.
///
/// The `navigationController` property is used to push and present view controllers.
/// When a coordinator wants to navigate to a new view controller, it should push the view controller onto the navigation stack.
/// When a coordinator wants to present a view controller modally, it should present the view controller from the navigation controller.
///
/// Example of a coordinator:
///
/// ```swift
/// class MainCoordinator: Coordinator {
///
///   var navigationController: UINavigationController
///
///   init(navigationController: UINavigationController) {
///     self.navigationController = navigationController
///   }
///
///   func start() {
///     let viewController = MainViewController()
///     viewController.coordinator = self
///     navigationController.pushViewController(viewController, animated: false)
///   }
///
///   func showDetail() {
///     let viewController = DetailViewController()
///     viewController.coordinator = self
///     navigationController.pushViewController(viewController, animated: true)
///   }
/// }
/// ```
protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  func start()
}

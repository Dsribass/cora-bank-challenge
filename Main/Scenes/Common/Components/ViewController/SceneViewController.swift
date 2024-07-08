import UIKit
import Combine

/// A custom view controller class to be used in the app. It provides a set of helper methods to work with UIKit and Combine.
///
/// This class uses a generic parameter `View` to specify the type of its main view.
/// When the view controller's view is loaded, it will automatically create an instance of `View`
/// and cast it to the specified type. The custom view can then be accessed via the `contentView` property.
///
/// You can override the following methods to tailor the setup of the view:
/// - `setupLayout`: Configure the layout of the view.
/// - `setupSubviews`: Add subviews to the view.
/// - `setupConstraints`: Define layout constraints for the subviews.
/// - `additionalConfigurations`: Apply additional configurations to the view.
///
/// For working with Combine, the `bindings` set is available to store cancellables and manage subscriptions effectively.
/// Override the `setupBindings()` method to establish specific Combine bindings. Additionally, use the `listenState(of:_:)` and `listenAction(of:_:)`
/// methods to observe state and action publishers, respectively.
///
/// Example usage:
/// ```swift
/// // Define a custom view subclass
/// class MyCustomView: UIView {
///     // Custom subviews and properties
///     let label: UILabel = {
///         let label = UILabel()
///         label.text = "Hello, World!"
///         label.textAlignment = .center
///         return label
///     }()
///
///     override init(frame: CGRect) {
///         super.init(frame: frame)
///         // Add custom subviews
///         addSubview(label)
///     }
///
///     required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
/// }
///
/// // Define a view controller subclass using MyCustomView
/// class MyViewController: SceneViewController<MyCustomView> {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         // Use `contentView` as an instance of MyCustomView
///         contentView.label.text = "Welcome to My App"
///     }
///
///     override func setupLayout() {
///         // Configure the layout of the view
///     }
///
///     override func setupSubviews() {
///         // Add subviews to the view if needed
///     }
///
///     override func setupConstraints() {
///         // Define layout constraints for the subviews
///         contentView.label.translatesAutoresizingMaskIntoConstraints = false
///         NSLayoutConstraint.activate([
///             contentView.label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
///             contentView.label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
///         ])
///     }
///
///     override func setupBindings() {
///         // Establish Combine bindings
///     }
///
///     override func additionalConfigurations() {
///         // Apply additional configurations to the view
///     }
/// }
/// ```
class SceneViewController<View: UIView>: UIViewController, ViewCodable, SkeletonHandler {
  /// An array to hold skeleton views and their associated gradient layers.
  var skeletonViews: [(view: UIView, layer: CAGradientLayer)] = .init()
  
  /// A computed property to get the view as the specified generic type `View`.
  var contentView: View { view as! View }
  
  /// A set to hold Combine cancellables for managing subscriptions.
  var bindings = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.backButtonDisplayMode = .minimal
    setupView()
    setupBindings()
  }
  
  override func loadView() {
    self.view = View()
  }
  
  /// Sets up Combine subscriptions. Override this method in subclasses to provide specific bindings.
  /// - Tag: setupBindings
  func setupBindings() {}
  
  /// Sets up the layout of the view. Override this method in subclasses to provide specific layout setup.
  func setupLayout() {}
  
  /// Adds subviews to the view. Override this method in subclasses to provide specific subview setup.
  func setupSubviews() {}
  
  /// Sets up constraints for the subviews. Override this method in subclasses to provide specific constraints.
  func setupConstraints() {}
  
  /// Applies additional configurations to the view. Override this method in subclasses to provide specific configurations.
  func additionalConfigurations() {}
}


extension SceneViewController {
  /// Listens to a state subject and calls the provided completion handler when the state changes.
  /// - Parameters:
  ///   - stateSubject: A publisher that emits state changes.
  ///   - completion: A closure that is called with the new state.
  /// - Returns: A cancellable instance that can be used to cancel the subscription.
  func listenState<S: State>(
    of stateSubject: AnyPublisher<S, Never>,
    _ completion: @escaping (S) -> ()
  ) -> AnyCancellable {
    stateSubject
      .receive(on: DispatchQueue.main)
      .sink { completion($0) }
  }
  
  /// Listens to an action subject and calls the provided completion handler when an action is emitted.
  /// - Parameters:
  ///   - actionSubject: A publisher that emits actions.
  ///   - completion: A closure that is called with the new action.
  /// - Returns: A cancellable instance that can be used to cancel the subscription.
  func listenAction<A: Action>(
    of actionSubject: AnyPublisher<A, Never>,
    _ completion: @escaping (A) -> ()
  ) -> AnyCancellable {
    actionSubject
      .receive(on: DispatchQueue.main)
      .sink { completion($0) }
  }
}


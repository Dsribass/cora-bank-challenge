import UIKit

class ApplicationCoordinator: Coordinator {
  var window: UIWindow
  var navigationController: UINavigationController

  init(window: UIWindow) {
    self.window = window
    self.navigationController = CoraNavigationController()
  }

  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    let introCoordinator = IntroCoordinator(nav: navigationController)
    introCoordinator.start()
  }
}

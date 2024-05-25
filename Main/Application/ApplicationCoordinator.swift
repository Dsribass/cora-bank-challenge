import UIKit
import Domain
import Combine

class ApplicationCoordinator: Coordinator {
  private var subscriptions = Set<AnyCancellable>()

  var window: UIWindow
  var navigationController: UINavigationController
  private let authStatePublisher: CurrentValueSubject<AuthState, Never>
  
  init(
    window: UIWindow,
    authStatePublisher: CurrentValueSubject<AuthState, Never>,
    getUserToken: GetUserToken
  ) {
    self.window = window
    self.authStatePublisher = authStatePublisher
    self.navigationController = CoraNavigationController()

    loadAuthState(getUserToken)
  }

  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    authStatePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
      switch state {
      case .loggedIn: self?.startApplicationFlow()
      case .loggedOut: self?.startAuthenticationFlow()
      default: self?.startAuthenticationFlow()
      }
    }
    .store(in: &subscriptions)
  }

  private func startAuthenticationFlow() {
    let authCoordinator = AuthCoordinator(nav: navigationController)
    authCoordinator.start()
  }

  private func startApplicationFlow() {
    let bankStatementCoordinator = BankStatementCoordinator(nav: navigationController)
    bankStatementCoordinator.start()
  }
}

extension ApplicationCoordinator {
  private func loadAuthState(_ getUserToken: GetUserToken) {
    getUserToken.execute(())
      .sink { [weak self] completion in
        switch completion {
        case .failure(_): self?.authStatePublisher.send(.loggedOut)
        case .finished: break
        }
      } receiveValue: { [weak self] _ in
        self?.authStatePublisher.send(.loggedIn)
        // TODO: Implement loading
      }
      .store(in: &subscriptions)
  }
}

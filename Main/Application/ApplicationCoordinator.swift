import UIKit
import Domain
import Combine

class ApplicationCoordinator: Coordinator {
  init(
    window: UIWindow,
    loadAuthState: LoadAuthState,
    logOutUser: LogOutUser,
    refreshToken: RefreshToken,
    authStatePublisher: AuthStatePublisher
  ) {
    self.navigationController = CoraNavigationController()
    self.window = window
    self.loadAuthState = loadAuthState
    self.logOutUser = logOutUser
    self.refreshToken = refreshToken
    self.authStatePublisher = authStatePublisher

    loadApplicationState()
  }

  private let loadAuthState: LoadAuthState
  private let logOutUser: LogOutUser
  private let refreshToken: RefreshToken
  private let authStatePublisher: AuthStatePublisher

  var window: UIWindow
  var navigationController: UINavigationController
  private var subscriptions = Set<AnyCancellable>()
  
  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    listenAuthStatePublisher(
      onIdle: { [unowned self] in
        showLoadingView()
      },
      onLoggedIn: { [unowned self] in
        startApplicationFlow()
        timer.resume()
      },
      onLoggedOut: { [unowned self] in
        startAuthenticationFlow()
        timer.suspend()
      }
    )
  }

  private lazy var timer: DispatchSourceTimer = {
    let timer = DispatchSource.makeTimerSource(
      queue: DispatchQueue.global(qos: .background))
    timer.schedule(deadline: .now(), repeating: 60.0)
    timer.setEventHandler { [weak self] in
      guard let self = self else { return }
      onRefreshToken()
    }

    return timer
  }()
}

extension ApplicationCoordinator {
  private func listenAuthStatePublisher(
    onIdle: @escaping () -> (),
    onLoggedIn: @escaping () -> (),
    onLoggedOut: @escaping () -> ()
  ) {
    authStatePublisher
      .receive(on: DispatchQueue.main)
      .sink { state in
        guard let state = state else {
          return onIdle()
        }

        switch state {
        case .loggedIn: onLoggedIn()
        case .loggedOut: onLoggedOut()
        default: onLoggedOut()
        }
      }
      .store(in: &subscriptions)
  }

  private func loadApplicationState() {
    loadAuthState.execute(())
      .sink { _ in } receiveValue: { _ in }
      .store(in: &subscriptions)
  }

  private func showLoadingView() {
    navigationController.setViewControllers([LoadingViewController()], animated: false)
  }

  private func startAuthenticationFlow() {
    let authCoordinator = AuthCoordinator(nav: navigationController)
    authCoordinator.start()
  }

  private func startApplicationFlow() {
    let bankStatementCoordinator = BankStatementCoordinator(nav: navigationController)
    bankStatementCoordinator.start()
  }

  private func onRefreshToken() {
    refreshToken.execute(())
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else {
            return
          }

          if case .failure(_) = completion {
            self.logOutUser.execute(())
              .catch { _ in Just(()) }
              .sink(receiveValue: { _ in})
              .store(in: &self.subscriptions)
          }
        },
        receiveValue: { _ in }
      )
      .store(in: &self.subscriptions)
  }
}

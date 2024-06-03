import UIKit
import Domain
import Combine

class ApplicationCoordinator: Coordinator {
  private var subscriptions = Set<AnyCancellable>()

  var window: UIWindow
  var navigationController: UINavigationController
  private let refreshToken: RefreshToken
  private let logout: LogOutUser
  private let authStatePublisher: CurrentValueSubject<AuthState, Never>
  private var timerSubscription: AnyCancellable?

  init(
    window: UIWindow,
    authStatePublisher: CurrentValueSubject<AuthState, Never>,
    getUserToken: GetUserToken,
    refreshToken: RefreshToken,
    logout: LogOutUser
  ) {
    self.navigationController = CoraNavigationController()

    self.window = window
    self.authStatePublisher = authStatePublisher
    self.refreshToken = refreshToken
    self.logout = logout

    loadAuthState(getUserToken)
  }

  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    authStatePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .loggedIn:
          self?.startApplicationFlow()
          self?.startRefreshTokenTimer()
        case .loggedOut:
          self?.startAuthenticationFlow()
          self?.stopRefreshTokenTimer()
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


  private func startRefreshTokenTimer() {
    let interval = 60.0
    timerSubscription = Timer
      .publish(every: interval, on: .main, in: .common)
      .autoconnect()
      .print("RefreshToken")
      .sink { [weak self] _ in
        guard let self = self else { return }
        refreshToken.execute(())
          .sink(
            receiveCompletion: { [weak self] completion in
              guard let self = self else {
                return
              }

              if case .failure(let failure) = completion {
                self.logout.execute(())
                  .sink(receiveValue: { _ in})
                  .store(in: &self.subscriptions)
              }
            },
            receiveValue: { _ in }
          )
          .store(in: &self.subscriptions)
      }
  }

  private func stopRefreshTokenTimer() { timerSubscription?.cancel() }
}

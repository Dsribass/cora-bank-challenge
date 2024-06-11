//
//  SceneDelegate.swift
//  CoraBankChallenge
//
//  Created by Daniel de Souza Ribas on 26/04/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var applicationCoordinator: ApplicationCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let window = createUIWindow(scene: scene) else {
      return
    }

    let applicationCoordinator = ApplicationCoordinator(
      window: window,
      loadAuthState: Factory.Domain.makeLoadAuthState(),
      logOutUser: Factory.Domain.makeLogOutUser(),
      refreshToken: Factory.Domain.makeRefreshToken(),
      authStatePublisher: Factory.authPublisher
    )
    applicationCoordinator.start()

    self.applicationCoordinator = applicationCoordinator
  }

  private func createUIWindow(scene: UIScene) -> UIWindow? {
    guard let windowScene = (scene as? UIWindowScene) else { return nil }
    let window = UIWindow(windowScene: windowScene)
    window.backgroundColor = .systemBackground
    window.frame = UIScreen.main.bounds

    return window
  }
}


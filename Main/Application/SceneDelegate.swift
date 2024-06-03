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
      authStatePublisher: Factory.authPublisher,
      getUserToken: Factory.Domain.makeGetUserToken(),
      refreshToken: Factory.Domain.makeRefreshToken(),
      logout: Factory.Domain.makeLogOutUser())
    applicationCoordinator.start()

    self.applicationCoordinator = applicationCoordinator
  }

  private func createUIWindow(scene: UIScene) -> UIWindow? {
    guard let windowScene = (scene as? UIWindowScene) else { return nil }
    let window = UIWindow(windowScene: windowScene)
    window.frame = UIScreen.main.bounds

    return window
  }
}


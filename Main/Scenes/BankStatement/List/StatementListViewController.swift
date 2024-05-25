import UIKit
import Combine

class StatementListViewController: SceneViewController<StatementListView> {
  private lazy var logoutButton = {
    UIBarButtonItem(
      image: UIImage(named: .icSignOut),
      style: .plain,
      target: self,
      action: #selector(handleLogoutButtonTap))
  }()

  override func additionalConfigurations() {
    navigationItem.title = LocalizedStrings.bankStatementTitle
    navigationItem.rightBarButtonItem = logoutButton
  }

  // TODO: Refactor
  @objc private func handleLogoutButtonTap() {
    let logout = Factory.Domain.makeLogOutUser()

    logout.execute(()).sink { _ in }.store(in: &bindings)
  }
}

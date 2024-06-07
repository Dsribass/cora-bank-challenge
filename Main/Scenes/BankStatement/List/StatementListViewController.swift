import UIKit
import Domain
import Combine

class StatementListViewController: SceneViewController<StatementListView> {
  private lazy var logoutButton = {
    UIBarButtonItem(
      image: UIImage(named: .icSignOut),
      style: .plain,
      target: self,
      action: #selector(handleLogoutButtonTap))
  }()

  private let statementsByDate: [StatementsByDate] = [
    (
      statements: [
        Domain.Statement(id: "1", description: "Hello World", label: "Hello World", entry: .debit, amount: 43, name: "Hello World", dateEvent: .now, status: .completed

                        ),
        Domain.Statement(id: "2", description: "Hello World", label: "Hello World", entry: .debit, amount: 12, name: "Hello World", dateEvent: .now, status: .completed

                        )
      ],
      date: .now
    ),
    (
      statements: [
        Domain.Statement(id: "3", description: "Hello World", label: "Hello World", entry: .debit, amount: 54, name: "Hello World", dateEvent: .now, status: .completed

                        ),
        Domain.Statement(id: "4", description: "Hello World", label: "Hello World", entry: .debit, amount: 66, name: "Hello World", dateEvent: .now, status: .completed

                        )
      ],
      date: .now
    )
  ]

  private lazy var flattenStatements = statementsByDate.flatMap { $0.statements }

  override func additionalConfigurations() {
    navigationItem.title = LocalizedStrings.bankStatementTitle
    navigationItem.rightBarButtonItem = logoutButton

    contentView.tableView.register(StatementCell.self, forCellReuseIdentifier: StatementCell.identifier)
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = self
  }

  // TODO: Refactor
  @objc private func handleLogoutButtonTap() {
    let logout = Factory.Domain.makeLogOutUser()

    logout
      .execute(())
      .catch { _ in Just(()) }
      .sink { _ in }.store(in: &bindings)
  }
}

extension StatementListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    statementsByDate[section].statements.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    statementsByDate.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StatementCell.identifier, for: indexPath) as? StatementCell ?? StatementCell()

    let statement = flattenStatements[indexPath.row]
    cell.config(statement: statement, icon: UIImage(named: .icArrowDownIn)!)

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    Constants.largeSpacing
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return StatementHeaderCell(date: self.statementsByDate[section].date)
  }
}

import UIKit
import Domain

class StatementsTableViewLoader: NSObject, UITableViewDelegate, UITableViewDataSource {
  init(tableView: UITableView) {
    tableView.register(StatementCell.self, forCellReuseIdentifier: StatementCell.identifier)
  }

  var statementsByDate: [StatementsByDate] = []

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    statementsByDate[section].statements.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    statementsByDate.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StatementCell.identifier, for: indexPath) as? StatementCell ?? StatementCell()

    let statement = statementsByDate[indexPath.section].statements[indexPath.row]
    cell.config(statement: statement, icon: UIImage(named: .icArrowDownIn)!)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    Constants.largeSpacing
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    StatementHeaderCell(date: self.statementsByDate[section].date)
  }
}

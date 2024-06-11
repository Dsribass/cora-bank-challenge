import UIKit

class SkeletonTableViewLoader: NSObject, UITableViewDelegate, UITableViewDataSource {
  init(tableView: UITableView) {
    tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.identifier)
  }

  struct SkeletonData {
    static let sections = 2
    static let items = 4
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { SkeletonData.items }

  func numberOfSections(in tableView: UITableView) -> Int { SkeletonData.sections }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: SkeletonCell.identifier, for: indexPath) as? SkeletonCell ?? SkeletonCell()
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    Spacing.large
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .gray4
    return view
  }
}

import UIKit
import Combine

class StatementDetailViewController: SceneViewController<StatementDetailView> {
  init(id: String) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  private let id: String
}

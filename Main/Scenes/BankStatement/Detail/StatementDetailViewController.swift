import UIKit
import Combine

class StatementDetailViewController: SceneViewController<StatementDetailView> {
  init(viewModel: StatementDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  private let viewModel: StatementDetailViewModel

  override func setupLayout() {
    navigationItem.title = Strings.StatementDetail.navBarTitle
    setupSkeletonViews([
      contentView.title,
      contentView.amountSection,
      contentView.dateSection,
      contentView.senderSection,
      contentView.receiverSection,
      contentView.transactionDescription
    ])
  }

  override func setupBindings() {
    listenState(of: viewModel.stateSubject.eraseToAnyPublisher()) { [weak self] state in
      guard let self = self else { return }

      switch state {
      case .loaded(let statement):
        contentView.showSuccess(statement)
        hideSkeleton()
      case .loading:
        contentView.showLoading()
        showSkeleton()
      case .error:
        contentView.showError(message: "Error")
        hideSkeleton()
      }
    }
    .store(in: &bindings)
  }
}



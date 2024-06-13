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
    contentView.shareButton.publisher(for: .touchUpInside)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self = self else { return }

        let activityViewController = UIActivityViewController(
          activityItems: [Strings.StatementDetail.button],
          applicationActivities: nil)

        present(activityViewController, animated: true, completion: nil)
      }
      .store(in: &bindings)

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
        contentView.showError { [weak self] in
          self?.viewModel.sendEvent(.loadStatement)
        }
        hideSkeleton()
      }
    }
    .store(in: &bindings)
  }
}

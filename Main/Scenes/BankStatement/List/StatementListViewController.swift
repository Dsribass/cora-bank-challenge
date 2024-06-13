import UIKit
import Domain
import Combine

class StatementListViewController: SceneViewController<StatementListView> {
  init(viewModel: StatementListViewModel, router: StatementListRouter) {
    self.viewModel = viewModel
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  private let viewModel: StatementListViewModel
  private let router: StatementListRouter

  private lazy var skeletonTableViewLoader = {
    SkeletonTableViewLoader(tableView: contentView.tableView)
  }()

  private lazy var statementTableViewLoader = {
    StatementsTableViewLoader(tableView: contentView.tableView)
  }()

  override func setupBindings() {
    func bindViewModelToView() {
      listenState(of: viewModel.stateSubject.eraseToAnyPublisher()) { [weak self] state in
        guard let self = self else { return }

        switch state {
        case .loaded(let statements): handleSuccessState(statements)
        case .loading: handleLoadingState()
        case .error: handleErrorState()
        }
      }
      .store(in: &bindings)
    }

    func bindViewToViewModel() {
      statementTableViewLoader
        .didTapCell
        .receive(on: DispatchQueue.main)
        .sink { [weak self] statement in
          guard let self = self else { return }
          if let selectedIndexPath = contentView.tableView.indexPathForSelectedRow {
            contentView
              .tableView
              .deselectRow(at: selectedIndexPath, animated: true)
          }
          
          router.navigateToDetails(id: statement.id)
        }
        .store(in: &bindings)
    }


    bindViewModelToView()
    bindViewToViewModel()
  }

  override func additionalConfigurations() {
    navigationItem.title = Strings.BankStatement.title
    navigationItem.rightBarButtonItem = logoutButton

    contentView.tableView.delegate = skeletonTableViewLoader
    contentView.tableView.dataSource = skeletonTableViewLoader
  }

  private lazy var logoutButton = {
    UIBarButtonItem(
      image: UIImage(named: .icSignOut),
      style: .plain,
      target: self,
      action: #selector(handleLogoutButtonTap))
  }()

  @objc private func handleLogoutButtonTap() {
    let logout = Factory.Domain.makeLogOutUser()

    logout
      .execute(())
      .catch { _ in Just(()) }
      .sink { _ in }.store(in: &bindings)
  }
}

extension StatementListViewController {
  func handleLoadingState() {
    contentView.tableView.delegate = skeletonTableViewLoader
    contentView.tableView.dataSource = skeletonTableViewLoader
    contentView.tableView.reloadData()
  }

  func handleSuccessState(_ statements: [StatementsByDate]) {
    statementTableViewLoader.statementsByDate = statements
    contentView.tableView.delegate = statementTableViewLoader
    contentView.tableView.dataSource = statementTableViewLoader
    contentView.tableView.reloadData()
  }

  func handleErrorState() {
    contentView.showErrorView { [weak self] in self?.viewModel.sendEvent(.load) }
  }
}

protocol StatementListRouter {
  func navigateToDetails(id: String)
}

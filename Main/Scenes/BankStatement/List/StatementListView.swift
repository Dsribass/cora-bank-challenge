import UIKit

class StatementListView: UIViewCodable {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()

  lazy var menuBar: UISegmentedControl = {
    let segmentedControl = UISegmentedControl()

    segmentedControl.insertSegment(
      withTitle: Strings.BankStatement.firstFilterTab,
      at: 0,
      animated: true)
    segmentedControl.insertSegment(
      withTitle: Strings.BankStatement.secondFilterTab,
      at: 1,
      animated: true)
    segmentedControl.insertSegment(
      withTitle: Strings.BankStatement.thirdFilterTab,
      at: 2,
      animated: true)
    segmentedControl.insertSegment(
      withTitle: Strings.BankStatement.fourthFilterTab,
      at: 3,
      animated: true)

    segmentedControl.selectedSegmentIndex = 0

    segmentedControl.selectedSegmentTintColor = .clear
    segmentedControl.tintColor = .clear
    segmentedControl.setDividerImage(UIImage().withTintColor(.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    segmentedControl.setBackgroundImage(UIImage().withTintColor(.clear), for: .normal, barMetrics: .default)

    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.font : UIFont.coraFont(for: .body2, weight: .regular),
      NSAttributedString.Key.foregroundColor: UIColor.Cora.gray1
    ], for: .normal)

    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.font : UIFont.coraFont(for: .body2, weight: .bold),
      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.foregroundColor: UIColor.Cora.primaryColor
    ], for: .selected)

    return segmentedControl
  }()

  lazy var filterConfigurations: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: .icFilter), for: .normal)

    return button
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.contentInset = .zero
    tableView.sectionHeaderTopPadding = 0
    return tableView
  }()

  override func setupLayout() {
    backgroundColor = .Cora.white
  }

  override func setupSubviews() {
    addSubview(menuBar)
    addSubview(filterConfigurations)
    addSubview(tableView)
  }

  override func setupConstraints() {
    filterConfigurations.makeConstraints {[
      $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
      $0.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
    ]}

    menuBar.makeConstraints {[
      $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Spacing.small),
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: filterConfigurations.trailingAnchor, constant: -Spacing.large),
      $0.heightAnchor.constraint(equalToConstant: 24)
    ]}

    tableView.makeConstraints {[
      $0.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: Spacing.small),
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]}
  }
}

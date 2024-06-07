import UIKit

class StatementListView: UIViewCodable {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()

  lazy var menuBar: UISegmentedControl = {
    let segmentedControl = UISegmentedControl()

    segmentedControl.insertSegment(withTitle: "Tudo", at: 0, animated: true)
    segmentedControl.insertSegment(withTitle: "Entrada", at: 1, animated: true)
    segmentedControl.insertSegment(withTitle: "Saída", at: 2, animated: true)
    segmentedControl.insertSegment(withTitle: "Futuro", at: 3, animated: true)
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
    filterConfigurations.makeConstraints { view in
      [
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing),
        view.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
      ]
    }

    menuBar.makeConstraints { view in
      [
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.smallSpacing),
        view.leadingAnchor.constraint(equalTo: leadingAnchor),
        view.trailingAnchor.constraint(equalTo: filterConfigurations.trailingAnchor, constant: -Constants.largeSpacing),
        view.heightAnchor.constraint(equalToConstant: 24)
      ]
    }

    tableView.makeConstraints { view in
      [
        view.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: Constants.smallSpacing),
        view.leadingAnchor.constraint(equalTo: leadingAnchor),
        view.trailingAnchor.constraint(equalTo: trailingAnchor),
        view.bottomAnchor.constraint(equalTo: bottomAnchor),
      ]
    }
  }
}

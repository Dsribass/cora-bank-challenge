import UIKit
import Domain

class StatementCell: UITableViewCell {
  static let identifier = String(describing: StatementCell.self)

  init(reuseIdentifier: String = identifier) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setupView()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier ?? StatementCell.identifier)
    setupView()
  }

  required init?(coder: NSCoder) { nil }

  private lazy var leadingIcon: UIImageView = UIImageView()

  private lazy var topSpacer = UIView()
  private lazy var bottomSpacer = UIView()

  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  private lazy var amount: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .body1, weight: .bold)
    return label
  }()

  private lazy var transctionDescription: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .body2, weight: .regular)
    return label
  }()

  private lazy var name: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .body2, weight: .regular)
    return label
  }()

  private lazy var date: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .small, weight: .regular)
    return label
  }()

  func config(statement: Statement, icon: UIImage) {
    amount.text = "\(statement.amount)"
    transctionDescription.text = statement.description
    name.text = statement.name
    leadingIcon.image = icon

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    date.text = formatter.string(from: statement.dateEvent)
  }
}

extension StatementCell: ViewCodable {
  func setupLayout() {}

  func setupSubviews() {
    addSubview(topSpacer)
    addSubview(leadingIcon)

    addSubview(stackView)
    stackView.addArrangedSubview(amount)
    stackView.addArrangedSubview(transctionDescription)
    stackView.addArrangedSubview(name)

    addSubview(date)
    addSubview(bottomSpacer)
  }

  func setupConstraints() {
    topSpacer.makeConstraints { [
      $0.heightAnchor.constraint(equalToConstant: 12),
      $0.topAnchor.constraint(equalTo: topAnchor),
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor)
    ] }

    leadingIcon.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumSpacing),
      $0.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
      $0.widthAnchor.constraint(equalToConstant: Constants.mediumSpacing),
      $0.heightAnchor.constraint(equalToConstant: Constants.mediumSpacing),
    ]}

    stackView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingIcon.trailingAnchor, constant: Constants.smallSpacing),
      $0.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor)
    ]}

    date.makeConstraints {[
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing),
      $0.centerYAnchor.constraint(equalTo: centerYAnchor),
      $0.widthAnchor.constraint(equalToConstant: 32)
    ]}

    bottomSpacer.makeConstraints { [
      $0.heightAnchor.constraint(equalToConstant: 12),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor),
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor)
    ] }
  }

  func additionalConfigurations() {}
}

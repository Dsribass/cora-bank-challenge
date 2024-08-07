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

  func config(statement: StatementSummary) {
    name.text = statement.name
    transctionDescription.text = statement.description
    amount.text = statement.amount.convertToCurrencyFormat()
    date.text = statement.dateEvent.hourMinuteFormat()

    switch (statement.entry) {
    case .credit: 
      leadingIcon.image = UIImage(named: .icArrowDownIn)?.withTintColor(.Cora.secondaryColor)
      transctionDescription.textColor = .Cora.secondaryColor
      amount.textColor = .Cora.secondaryColor
    case .debit:
      leadingIcon.image = UIImage(named: .icArrowUpOut)?.withTintColor(.Cora.offBlack)
      transctionDescription.textColor = .Cora.offBlack
      amount.textColor = .Cora.offBlack
    default:
      break
    }
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    backgroundColor = highlighted ? .Cora.gray4 : .Cora.white
  }
}

extension StatementCell: ViewCodable {
  func setupLayout() {
    selectionStyle = .none
  }

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
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      $0.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
      $0.widthAnchor.constraint(equalToConstant: Spacing.medium),
      $0.heightAnchor.constraint(equalToConstant: Spacing.medium),
    ]}

    stackView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingIcon.trailingAnchor, constant: Spacing.small),
      $0.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor)
    ]}

    date.makeConstraints {[
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
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

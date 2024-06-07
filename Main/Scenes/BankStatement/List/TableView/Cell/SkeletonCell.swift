import UIKit

// TODO: Add animation
class SkeletonCell: UITableViewCell {
  static let identifier = String(describing: SkeletonCell.self)

  init(reuseIdentifier: String = identifier) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setupView()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier ?? SkeletonCell.identifier)
    setupView()
  }

  required init?(coder: NSCoder) { nil }

  private lazy var stack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .leading
    stack.distribution = .fill
    return stack
  }()

  private lazy var topSpacer = UIView()
  private lazy var bottomSpacer = UIView()

  private lazy var firstBox: UIView = {
    let view =  UIView()
    view.backgroundColor = .Cora.gray3
    view.layer.cornerRadius = 4
    return view
  }()

  private lazy var secondBox: UIView = {
    let view =  UIView()
    view.backgroundColor = .Cora.gray3
    view.layer.cornerRadius = 4
    return view
  }()
}

extension SkeletonCell: ViewCodable {
  func setupLayout() {}

  func setupSubviews() {
    addSubview(stack)

    stack.addArrangedSubview(topSpacer)
    stack.addArrangedSubview(firstBox)
    stack.setCustomSpacing(10, after: firstBox)
    stack.addArrangedSubview(secondBox)
    stack.addArrangedSubview(bottomSpacer)
  }

  func setupConstraints() {
    topSpacer.makeConstraints {[
      $0.heightAnchor.constraint(equalToConstant: 12),
    ]}

    stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
    stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    stack.makeConstraints {[
      $0.topAnchor.constraint(equalTo: topAnchor),
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumSpacing),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]}

    firstBox.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    firstBox.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    firstBox.makeConstraints {[
      $0.heightAnchor.constraint(equalToConstant: 38),
      $0.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.7)
    ]}
    
    secondBox.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    secondBox.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    secondBox.makeConstraints {[
      $0.heightAnchor.constraint(equalToConstant: 16),
      $0.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.5)
    ]}

    bottomSpacer.makeConstraints {[
      $0.heightAnchor.constraint(equalToConstant: 12),
    ]}
  }

  func additionalConfigurations() {}
}

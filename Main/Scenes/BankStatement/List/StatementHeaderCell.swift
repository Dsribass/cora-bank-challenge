import UIKit

class StatementHeaderCell: UIViewCodable {
  init(date: Date) {
    super.init(frame: .zero)
    config(date: date)
  }
  
  required init?(coder: NSCoder) { nil }
  
  private func config(date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE - d 'de' MMMM"
    label.text = dateFormatter.string(from: date)
  }

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .small, weight: .regular)
    label.textColor = .Cora.gray1
    return label
  }()

  override func setupLayout() {
    super.setupLayout()

    backgroundColor = .Cora.gray4
  }

  override func setupSubviews() {
    addSubview(label)
  }

  override func setupConstraints() {
    label.makeConstraints { view in
      [
        view.centerYAnchor.constraint(equalTo: centerYAnchor),
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumSpacing),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing)
      ]
    }
  }
}

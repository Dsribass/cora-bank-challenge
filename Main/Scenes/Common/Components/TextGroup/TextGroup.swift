import UIKit

class TextGroup: UIViewCodable {
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .body2, weight: .regular)
    label.textColor = .Cora.offBlack
    return label
  }()

  private lazy var title: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .body1, weight: .bold)
    label.textColor = .Cora.offBlack
    return label
  }()

  private lazy var descriptionList: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .coraFont(for: .body2, weight: .regular)
    label.textColor = .Cora.gray1
    return label
  }()

  func config(label: String, title: String?, descriptionList: [String] = []) {
    if title == nil {
      self.title.isHidden = true
    }

    self.label.text = label
    self.title.text = title
    self.descriptionList.text = descriptionList.joined(separator: "\n")
  }

  override func setupSubviews() {
    addSubview(stackView)

    stackView.addArrangedSubview(label)
    stackView.setCustomSpacing(4, after: label)
    stackView.addArrangedSubview(title)
    stackView.setCustomSpacing(4, after: title)
    stackView.addArrangedSubview(descriptionList)
  }

  override func setupConstraints() {
    stackView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor),
      $0.topAnchor.constraint(equalTo: topAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]}
  }
}

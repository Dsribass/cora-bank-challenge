import UIKit
import Combine

class GenericErrorView: UIViewCodable {
  func configure(
    title: String,
    message: String,
    onRetryAction: @escaping () -> Void
  ) {
    self.title.text = title
    self.message.text = message
    self.onRetryAction = onRetryAction
  }

  private var onRetryAction: (() -> Void)?

  private lazy var stack = {
    let stack = UIStackView()
    stack.alignment = .center
    stack.axis = .vertical
    return stack
  }()

  lazy var title: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .title2, weight: .bold)
    return label
  }()

  lazy var message: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = .coraFont(for: .body1, weight: .regular)
    return label
  }()

  lazy var retryButton: CoraButton = {
    let button = CoraButton(title: Strings.Error.button, size: .small, variation: .primary, color: .brand)
    button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    return button
  }()

  @objc private func didTapRetry() {
      onRetryAction?()
  }

  override func setupLayout() {
    backgroundColor = .Cora.white
  }

  override func setupSubviews() {
    addSubview(stack)

    stack.addArrangedSubview(title)
    stack.setCustomSpacing(Spacing.small, after: title)
    stack.addArrangedSubview(message)
    stack.setCustomSpacing(Spacing.medium, after: message)
    stack.addArrangedSubview(retryButton)
  }

  override func setupConstraints() {
    stack.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
      $0.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]}

    retryButton.makeConstraints{[
      $0.widthAnchor.constraint(equalTo: stack.widthAnchor)
    ]}
  }
}

extension UIView {
  func showErrorView(message: String? = nil, _ onRetry: @escaping () -> Void) {
    let errorView = GenericErrorView()
    errorView.configure(
      title: Strings.Error.title,
      message: message ?? Strings.Error.message,
      onRetryAction: onRetry)

    addSubview(errorView)

    errorView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor),
      $0.topAnchor.constraint(equalTo: topAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]}
  }

  func hideErrorView() {
    subviews.forEach { view in
      if let errorView = view as? GenericErrorView {
        errorView.removeFromSuperview()
      }
    }
  }
}

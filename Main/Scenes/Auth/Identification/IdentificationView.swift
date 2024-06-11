import UIKit

class IdentificationView: UIViewCodable {
  lazy var content: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  lazy var greetingsMessage: UILabel = {
    let label = UILabel()
    label.text = Strings.Identification.pageGreetings
    label.font = UIFont.coraFont(for: .body1, weight: .regular)
    label.textColor = .Cora.gray1
    return label
  }()

  lazy var identificationQuestion: UILabel = {
    let label = UILabel()
    label.text = Strings.Identification.cpf
    label.font = UIFont.coraFont(for: .title2, weight: .bold)
    label.textColor = .Cora.black
    return label
  }()

  lazy var textField: UITextField = {
    let tf = UITextField()
    tf.textColor = .Cora.offBlack
    tf.font = UIFont.coraFont(for: .title2, weight: .regular)
    tf.keyboardType = .numberPad

    return tf
  }()

  lazy var textFieldErrorMessage: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .body1, weight: .bold)
    label.textColor = .red

    return label
  }()

  lazy var nextStepButton: CoraButton = {
    CoraButton(
      title: Strings.Login.nextStepButton,
      size: .small,
      variation: .primary,
      color: .brand,
      image: UIImage(named: .icArrowRight))
  }()

  override func setupLayout() {
    backgroundColor = .Cora.white
  }

  override func setupSubviews() {
    addSubview(content)

    content.addArrangedSubview(greetingsMessage)
    content.setCustomSpacing(Spacing.small / 2, after: greetingsMessage)
    content.addArrangedSubview(identificationQuestion)
    content.setCustomSpacing(Spacing.large, after: identificationQuestion)
    content.addArrangedSubview(textField)
    content.setCustomSpacing(Spacing.small, after: textField)
    content.addArrangedSubview(textFieldErrorMessage)

    addSubview(nextStepButton)
  }

  override func setupConstraints() {
    content.makeConstraints { view in
      [
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Spacing.medium),
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium)
      ]
    }

    nextStepButton.makeConstraints { view in
      [
        view.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -Spacing.small),
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium)
      ]
    }
  }
}

import UIKit

class IdentificationView: UIViewCodable {
  lazy var content: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  lazy var greetingsMessage: UILabel = {
    let label = UILabel()
    label.text = LocalizedStrings.identificationPageGreetings
    label.font = UIFont.coraFont(for: .body1, weight: .regular)
    label.textColor = .Cora.gray1
    return label
  }()

  lazy var identificationQuestion: UILabel = {
    let label = UILabel()
    label.text = LocalizedStrings.identificationCpf
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
      title: LocalizedStrings.loginNextStepButton,
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
    content.setCustomSpacing(Constants.smallSpacing / 2, after: greetingsMessage)
    content.addArrangedSubview(identificationQuestion)
    content.setCustomSpacing(Constants.largeSpacing, after: identificationQuestion)
    content.addArrangedSubview(textField)
    content.setCustomSpacing(Constants.smallSpacing, after: textField)
    content.addArrangedSubview(textFieldErrorMessage)

    addSubview(nextStepButton)
  }

  override func setupConstraints() {
    content.makeConstraints { view in
      [
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.mediumSpacing),
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumSpacing),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing)
      ]
    }

    nextStepButton.makeConstraints { view in
      [
        view.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -Constants.smallSpacing),
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumSpacing),
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumSpacing)
      ]
    }
  }
}

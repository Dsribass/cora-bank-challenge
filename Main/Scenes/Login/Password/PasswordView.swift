import UIKit

class PasswordView: UIViewCodable {
  lazy var content: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  lazy var passwordQuestion: UILabel = {
    let label = UILabel()
    label.text = LocalizedStrings.passwordTitle
    label.font = UIFont.coraFont(for: .title2, weight: .bold)
    label.textColor = .Cora.black
    return label
  }()

  private lazy var textFieldVisibilityIcon: UIButton = {
    let button = UIButton(configuration: .plain())
    button.contentMode = .scaleAspectFill
    button.setTitle("", for: .normal)
    button.setImage(UIImage(named: .icEyeHidden), for: .normal)

    return button
  }()

  lazy var textField: UITextField = {
    let tf = UITextField()
    tf.rightView = textFieldVisibilityIcon
    tf.rightViewMode = .always
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

  lazy var forgotPasswordButton: UIButton = {
    let btn = UIButton(configuration: .plain())
    btn.setTitle(LocalizedStrings.passwordForgotPassword, for: .normal)
    btn.tintColor = .Cora.primaryColor
    btn.contentHorizontalAlignment = .leading
    btn.titleLabel?.font = UIFont.coraFont(for: .body2, weight: .regular)
    btn.configuration?.contentInsets = .zero

    return btn
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

    content.addArrangedSubview(passwordQuestion)
    content.setCustomSpacing(Constants.largeSpacing, after: passwordQuestion)
    content.addArrangedSubview(textField)
    content.setCustomSpacing(Constants.smallSpacing, after: textField)
    content.setCustomSpacing(Constants.smallSpacing, after: textField)
    content.addArrangedSubview(textFieldErrorMessage)
    content.setCustomSpacing(Constants.largeSpacing, after: textFieldErrorMessage)
    content.addArrangedSubview(forgotPasswordButton)

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

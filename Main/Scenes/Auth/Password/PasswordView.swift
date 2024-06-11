import UIKit

class PasswordView: UIViewCodable {
  lazy var content: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    return stack
  }()

  lazy var passwordQuestion: UILabel = {
    let label = UILabel()
    label.text = Strings.Password.title
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
    tf.isSecureTextEntry = true
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
    btn.setTitle(Strings.Password.forgotPassword, for: .normal)
    btn.tintColor = .Cora.primaryColor
    btn.contentHorizontalAlignment = .leading
    btn.titleLabel?.font = UIFont.coraFont(for: .body2, weight: .regular)
    btn.configuration?.contentInsets = .zero

    return btn
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

    content.addArrangedSubview(passwordQuestion)
    content.setCustomSpacing(Spacing.large, after: passwordQuestion)
    content.addArrangedSubview(textField)
    content.setCustomSpacing(Spacing.small, after: textField)
    content.setCustomSpacing(Spacing.small, after: textField)
    content.addArrangedSubview(textFieldErrorMessage)
    content.setCustomSpacing(Spacing.large, after: textFieldErrorMessage)
    content.addArrangedSubview(forgotPasswordButton)

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

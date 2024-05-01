import UIKit

class IntroView: UIViewCodable {
  lazy var backgroundImage: UIImageView = {
    let image = UIImageView(image: UIImage(named: .introBg))
    image.contentMode = .scaleAspectFill
    return image
  }()

  lazy var logo: UIImageView = {
    let image = UIImageView(image: UIImage(named: .logo))
    image.contentMode = .scaleAspectFill

    return image
  }()

  lazy var content: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical

    return stackView
  }()

  lazy var title: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .title1, weight: .bold)
    label.textColor = .Cora.onPrimaryColor
    label.text = LocalizedStrings.introTitle

    return label
  }()

  lazy var subtitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .title1, weight: .regular)
    label.textColor = .Cora.onPrimaryColor
    label.text = LocalizedStrings.introSubtitle

    return label
  }()

  lazy var information: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.font = UIFont.coraFont(for: .body1, weight: .regular)
    label.textColor = .Cora.onPrimaryColor
    label.text = LocalizedStrings.introDescription

    return label
  }()

  lazy var primaryButton: UIButton = {
    CoraButton(
      title: LocalizedStrings.introPrimaryButton,
      size: .medium,
      variation: .primary,
      color: .white,
      image: UIImage(named: .icArrowRight))
  }()

  lazy var secondaryButton: UIButton = {
    CoraButton(
      title: LocalizedStrings.introSecondaryButton,
      size: .small,
      variation: .primary,
      color: .brand)
  }()

  override func setupLayout() {
    backgroundColor = .Cora.primaryColor
  }

  override func setupSubviews() {
    addSubview(backgroundImage)
    addSubview(logo)

    addSubview(content)

    content.addArrangedSubview(title)
    content.addArrangedSubview(subtitle)
    content.setCustomSpacing(Constants.smallSpacing, after: subtitle)
    content.addArrangedSubview(information)
    content.setCustomSpacing(Constants.defaultSpacing, after: information)
    content.addArrangedSubview(primaryButton)
    content.setCustomSpacing(Constants.smallSpacing, after: primaryButton)
    content.addArrangedSubview(secondaryButton)
  }

  override func setupConstraints() {
    backgroundImage.makeConstraints { view in
      [
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.48),
        view.leftAnchor.constraint(equalTo: leftAnchor),
        view.rightAnchor.constraint(equalTo: rightAnchor),
        view.topAnchor.constraint(equalTo: topAnchor)
      ]
    }

    logo.makeConstraints { view in
      [
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultSpacing),
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
      ]
    }

    content.makeConstraints { view in
      [
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultSpacing),
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.defaultSpacing),
        view.topAnchor.constraint(equalTo: centerYAnchor, constant: Constants.smallSpacing)
      ]
    }
  }
}

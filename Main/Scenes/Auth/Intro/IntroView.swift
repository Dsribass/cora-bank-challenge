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
    label.textColor = .Cora.white
    label.text = Strings.Intro.title

    return label
  }()

  lazy var subtitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.coraFont(for: .title1, weight: .regular)
    label.textColor = .Cora.white
    label.text = Strings.Intro.subtitle

    return label
  }()

  lazy var information: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.font = UIFont.coraFont(for: .body1, weight: .regular)
    label.textColor = .Cora.white
    label.text = Strings.Intro.description

    return label
  }()

  lazy var primaryButton: CoraButton = {
    CoraButton(
      title: Strings.Intro.primaryButton,
      size: .medium,
      variation: .primary,
      color: .white,
      image: UIImage(named: .icArrowRight))
  }()

  lazy var secondaryButton: CoraButton = {
    CoraButton(
      title: Strings.Intro.secondaryButton,
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
    content.setCustomSpacing(Spacing.small, after: subtitle)
    content.addArrangedSubview(information)
    content.setCustomSpacing(Spacing.medium, after: information)
    content.addArrangedSubview(primaryButton)
    content.setCustomSpacing(Spacing.small, after: primaryButton)
    content.addArrangedSubview(secondaryButton)
  }

  override func setupConstraints() {
    backgroundImage.makeConstraints {[
      $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.48),
      $0.leftAnchor.constraint(equalTo: leftAnchor),
      $0.rightAnchor.constraint(equalTo: rightAnchor),
      $0.topAnchor.constraint(equalTo: topAnchor)
    ]}

    logo.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
    ]}

    content.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      $0.rightAnchor.constraint(equalTo: rightAnchor, constant: -Spacing.medium),
      $0.topAnchor.constraint(equalTo: centerYAnchor, constant: Spacing.small)
    ]}
  }
}

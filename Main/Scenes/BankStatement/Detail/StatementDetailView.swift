import UIKit
import Domain

class StatementDetailView: UIViewCodable {
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()

  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fill
    return stack
  }()

  lazy var title: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .body1, weight: .bold)
    label.textColor = .Cora.black
    label.numberOfLines = 1
    return label
  }()

  lazy var amountSection = TextGroup()

  lazy var dateSection = TextGroup()

  lazy var senderSection = TextGroup()

  lazy var receiverSection = TextGroup()

  lazy var transactionDescription = TextGroup()

  lazy var shareButton: CoraButton = {
    let button = CoraButton(title: Strings.StatementDetail.button, size: .medium, variation: .primary, color: .brand)

    button.image = UIImage(named: .icShare)
    return button
  }()

  func config(statement: Statement) {
    setTitle(statement.label, image: UIImage(named: .icArrowDownIn)!)

    amountSection.config(
      label: Strings.StatementDetail.amountSection,
      title: statement.amount.convertToCurrencyFormat())

    dateSection.config(
      label: Strings.StatementDetail.dateSection,
      title: statement.dateEvent.weekdayAndFullDate())

    let sender = statement.sender
    senderSection.config(
      label: Strings.StatementDetail.senderSection,
      title: sender.name,
      descriptionList: [
        "\(sender.documentType) \(sender.documentNumber)",
        sender.bankName,
        Strings.StatementDetail.bankInfo(
          agency: sender.agencyNumber,
          account: sender.accountNumber)
      ]
    )

    let receiver = statement.recipient
    receiverSection.config(
      label: Strings.StatementDetail.receiverSection,
      title: receiver.name,
      descriptionList: [
        "\(receiver.documentType) \(receiver.documentNumber)",
        receiver.bankName,
        Strings.StatementDetail.bankInfo(
          agency: receiver.agencyNumber,
          account: receiver.accountNumber)
      ]
    )

    transactionDescription.config(
      label: Strings.StatementDetail.descriptionSection,
      title: nil,
      descriptionList: [statement.description])
  }

  override func setupLayout() {
    backgroundColor = .Cora.white
  }

  private func setTitle(_ title: String, image: UIImage) {
    let attachment = NSTextAttachment(image: image)

    let imageOffsetY: CGFloat = -5
    attachment.bounds = CGRect(
      x: 0,
      y: imageOffsetY,
      width: image.size.width,
      height: image.size.height)

    let attachmentString = NSAttributedString(attachment: attachment)
    let completeText = NSMutableAttributedString()
    completeText.append(attachmentString)
    completeText.append(NSAttributedString(string: " " + (title)))
    self.title.attributedText = completeText
  }

  override func setupSubviews() {
    addSubview(scrollView)
    scrollView.addSubview(stackView)

    stackView.addArrangedSubview(title)
    stackView.setCustomSpacing(Spacing.medium, after: title)
    stackView.addArrangedSubview(amountSection)
    stackView.setCustomSpacing(Spacing.medium, after: amountSection)
    stackView.addArrangedSubview(dateSection)
    stackView.setCustomSpacing(Spacing.medium, after: dateSection)
    stackView.addArrangedSubview(senderSection)
    stackView.setCustomSpacing(Spacing.medium, after: senderSection)
    stackView.addArrangedSubview(receiverSection)
    stackView.setCustomSpacing(Spacing.medium, after: receiverSection)
    stackView.addArrangedSubview(transactionDescription)
    stackView.setCustomSpacing(Spacing.large, after: transactionDescription)
    stackView.addArrangedSubview(shareButton)
  }

  override func setupConstraints() {
    scrollView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.trailingAnchor.constraint(equalTo: trailingAnchor),
      $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ]}

    stackView.makeConstraints {[
      $0.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Spacing.medium),
      $0.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Spacing.medium),
      $0.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Spacing.large),
      $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Spacing.medium),
      $0.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Spacing.medium)
    ]}
  }
}

extension StatementDetailView: ViewState {
  func showSuccess(_ data: Statement) {
    config(statement: data)
    shareButton.isHidden = false
  }

  func showError(message: String? = nil, _ onRetry: @escaping () -> Void) {
    showErrorView(onRetry)
  }

  func showLoading() {
    let placeholderSender = Statement.Party(
      bankName: "Loading...",
      bankNumber: "",
      documentNumber: "",
      documentType: "",
      accountNumberDigit: "",
      agencyNumberDigit: "",
      agencyNumber: "",
      name: "Loading...",
      accountNumber: ""
    )

    let placeholderRecipient = Statement.Party(
      bankName: "Loading...",
      bankNumber: "",
      documentNumber: "",
      documentType: "",
      accountNumberDigit: "",
      agencyNumberDigit: "",
      agencyNumber: "",
      name: "Loading...",
      accountNumber: ""
    )

    let placeholderStatement = Statement(
      description: "Loading...",
      label: "Loading...",
      amount: 0.0,
      counterPartyName: "Loading...",
      id: "",
      dateEvent: Date(),
      recipient: placeholderRecipient,
      sender: placeholderSender,
      status: .completed
    )

    config(statement: placeholderStatement)
    shareButton.isHidden = true
  }
}


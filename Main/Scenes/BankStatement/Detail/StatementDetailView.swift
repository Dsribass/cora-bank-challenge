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

  private lazy var title: UILabel = {
    let label = UILabel()
    label.font = .coraFont(for: .body1, weight: .bold)
    label.textColor = .Cora.black
    label.numberOfLines = 1
    return label
  }()

  private lazy var amountSection = DetailSection()

  private lazy var dateSection = DetailSection()

  private lazy var senderSection = DetailSection()

  private lazy var receiverSection = DetailSection()

  private lazy var transactionDescription = DetailSection()

  private lazy var shareButton: CoraButton = {
    let button = CoraButton(title: LocalizedStrings.statementDetailButton, size: .medium, variation: .primary, color: .brand)

    button.image = UIImage(named: .icShare)
    return button
  }()

  func config(statement: Statement) {
    setTitle(statement.label, image: UIImage(named: .icArrowDownIn)!)

    amountSection.config(
      label: LocalizedStrings.statementDetailAmountSection,
      title: statement.amount.convertToCurrencyFormat())

    dateSection.config(
      label: LocalizedStrings.statementDetailDateSection,
      title: statement.dateEvent.weekdayAndFullDate())

    let sender = statement.sender
    senderSection.config(
      label: LocalizedStrings.statementDetailSenderSection,
      title: sender.name,
      descriptionList: [
        "\(sender.documentType) \(sender.documentNumber)",
        sender.bankName,
        LocalizedStrings.statementDetailBankInfo(
          agency: sender.agencyNumber,
          account: sender.accountNumber)
      ]
    )

    let receiver = statement.recipient
    receiverSection.config(
      label: LocalizedStrings.statementDetailReceiverSection,
      title: receiver.name,
      descriptionList: [
        "\(receiver.documentType) \(receiver.documentNumber)",
        receiver.bankName,
        LocalizedStrings.statementDetailBankInfo(
          agency: receiver.agencyNumber,
          account: receiver.accountNumber)
      ]
    )

    transactionDescription.config(
      label: LocalizedStrings.statementDetailDescriptionSection,
      title: nil,
      descriptionList: [statement.description])
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
    stackView.setCustomSpacing(Constants.mediumSpacing, after: title)
    stackView.addArrangedSubview(amountSection)
    stackView.setCustomSpacing(Constants.mediumSpacing, after: amountSection)
    stackView.addArrangedSubview(dateSection)
    stackView.setCustomSpacing(Constants.mediumSpacing, after: dateSection)
    stackView.addArrangedSubview(senderSection)
    stackView.setCustomSpacing(Constants.mediumSpacing, after: senderSection)
    stackView.addArrangedSubview(receiverSection)
    stackView.setCustomSpacing(Constants.mediumSpacing, after: receiverSection)
    stackView.addArrangedSubview(transactionDescription)
    stackView.setCustomSpacing(Constants.largeSpacing, after: transactionDescription)
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
      $0.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.mediumSpacing),
      $0.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.mediumSpacing),
      $0.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.largeSpacing),
      $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.mediumSpacing),
      $0.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Constants.mediumSpacing)
    ]}
  }
}

private class DetailSection: UIViewCodable {
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

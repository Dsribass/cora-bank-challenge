import Foundation
import Domain

struct StatementRemoteModel{
  struct Response: Decodable {
    init(description: String, label: String, amount: Int, counterPartyName: String, id: String, dateEvent: Date, recipient: Party, sender: Party, status: String) {
      self.description = description
      self.label = label
      self.amount = amount
      self.counterPartyName = counterPartyName
      self.id = id
      self.dateEvent = dateEvent
      self.recipient = recipient
      self.sender = sender
      self.status = status
    }

    let description: String
    let label: String
    let amount: Int
    let counterPartyName: String
    let id: String
    let dateEvent: Date
    let recipient: Party
    let sender: Party
    let status: String

    struct Party: Decodable {
      let bankName: String
      let bankNumber: String
      let documentNumber: String
      let documentType: String
      let accountNumberDigit: String
      let agencyNumberDigit: String
      let agencyNumber: String
      let name: String
      let accountNumber: String
    }
  }
}

extension StatementRemoteModel.Response {
  func toDM() throws -> Statement {
    guard let status = StatementStatus.from(string: status) else {
      throw DomainError.nonexistentItem
    }

    return Statement(
      description: description,
      label: label,
      amount: Double(amount),
      counterPartyName: counterPartyName,
      id: id,
      dateEvent: dateEvent,
      recipient: recipient.toDM(),
      sender: sender.toDM(),
      status: status
    )
  }
}

extension StatementRemoteModel.Response.Party {
  func toDM() -> Statement.Party {
    Statement.Party(bankName: bankName, bankNumber: bankNumber, documentNumber: documentNumber, documentType: documentType, accountNumberDigit: accountNumberDigit, agencyNumberDigit: agencyNumberDigit, agencyNumber: agencyNumber, name: name, accountNumber: accountNumber)
  }
}

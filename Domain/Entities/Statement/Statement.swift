import Foundation

public struct Statement {
  public init(description: String, label: String, amount: Double, counterPartyName: String, id: String, dateEvent: Date, recipient: Party, sender: Party, status: StatementStatus) {
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

  public let description: String
  public let label: String
  public let amount: Double
  public let counterPartyName: String
  public let id: String
  public let dateEvent: Date
  public let recipient: Party
  public let sender: Party
  public let status: StatementStatus

  public struct Party {
    public init(bankName: String, bankNumber: String, documentNumber: String, documentType: String, accountNumberDigit: String, agencyNumberDigit: String, agencyNumber: String, name: String, accountNumber: String) {
      self.bankName = bankName
      self.bankNumber = bankNumber
      self.documentNumber = documentNumber
      self.documentType = documentType
      self.accountNumberDigit = accountNumberDigit
      self.agencyNumberDigit = agencyNumberDigit
      self.agencyNumber = agencyNumber
      self.name = name
      self.accountNumber = accountNumber
    }

    public let bankName: String
    public let bankNumber: String
    public let documentNumber: String
    public let documentType: String
    public let accountNumberDigit: String
    public let agencyNumberDigit: String
    public let agencyNumber: String
    public let name: String
    public let accountNumber: String
  }
}

import Foundation

public struct StatementSummary {
  public init(
    id: String,
    description: String,
    label: String,
    entry: Entry,
    amount: Double,
    name: String,
    dateEvent: Date,
    status: StatementStatus
  ) {
    self.id = id
    self.description = description
    self.label = label
    self.entry = entry
    self.amount = amount
    self.name = name
    self.dateEvent = dateEvent
    self.status = status
  }

  public enum Entry {
    case debit, credit

    public static func from(string: String) -> Entry? {
      switch string {
      case "DEBIT": return .debit
      case "CREDIT": return .credit
      default: return nil
      }
    }
  }

  public let id: String
  public let description: String
  public let label: String
  public let entry: Entry
  public let amount: Double
  public let name: String
  public let dateEvent: Date
  public let status: StatementStatus
}

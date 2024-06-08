import Foundation
import Domain

struct StatementSummaryRemoteModel {
  struct Response: Decodable {
    struct Result: Decodable {
      let items: [Item]
      let date: String
    }

    struct Item: Decodable {
      let id: String
      let description: String
      let label: String
      let entry: String
      let amount: Int
      let name: String
      let dateEvent: Date
      let status: String
    }

    let results: [Result]
    let itemsTotal: Int
  }
}

extension StatementSummaryRemoteModel.Response {
  func toDM() throws -> [StatementsByDate] {
    try results.map { result in
      StatementsByDate(
        statements: try result.items.map { item in
          guard let entry = StatementSummary.Entry.from(string: item.entry),
                  let status = StatementStatus.from(string: item.status) else {
            throw DomainError.nonexistentItem
          }

          return StatementSummary(
            id: item.id, 
            description: item.description,
            label: item.label,
            entry: entry,
            amount: Double(item.amount),
            name: item.name,
            dateEvent: item.dateEvent,
            status: status)
        },
        date: {
          let isoDateFormatter = ISO8601DateFormatter()
          isoDateFormatter.formatOptions = [.withFullDate]
          return isoDateFormatter.date(from: result.date)!
        }()
      )
    }
  }
}

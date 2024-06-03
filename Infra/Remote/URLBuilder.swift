import Foundation

enum URLBuilder {
  static private let baseUrl = "https://api.challenge.stage.cora.com.br/challenge"

  static func auth() -> URL { URL(string: "\(baseUrl)/auth")! }
}

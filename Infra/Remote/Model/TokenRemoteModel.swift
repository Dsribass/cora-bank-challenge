import Foundation

struct TokenRemoteModel {
  struct Request: Encodable {
    let token: String
  }

  struct Response: Decodable {
    let token: String
  }
}


import Foundation

struct UserRemoteModel {
  struct Request: Encodable {
    let cpf: String
    let password: String
  }

  struct Response: Decodable {
    let token: String
  }
}

import Foundation
import Combine

public final class AuthRemoteDataSource {
  struct Request: Encodable {
    let cpf: String
    let password: String
  }

  struct Response: Decodable {
    let token: String
  }

  public init(session: URLSession) {
    self.session = session
  }

  private let session: URLSession

  func authenticate(request: Request) -> AnyPublisher<String, Error> {
    let url = URL(string: "http://127.0.0.1:3000/auth")!
    guard let body = try? JSONEncoder().encode(request) else {
      return AnyPublisher(Fail<String, Error>(error: NetworkError.decodingError))
    }

    return session
      .dataTaskPublisher(for: NetworkRequest.post(for: url, body: body))
      .tryMapToData()
      .decode(type: Response.self, decoder: JSONDecoder())
      .map { $0.token }
      .eraseToAnyPublisher()
  }
}

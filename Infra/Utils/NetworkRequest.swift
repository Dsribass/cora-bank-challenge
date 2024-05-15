import Foundation

struct NetworkRequest {
  private enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
  }

  static func get(
    for url: URL,
    with token: String? = nil
  ) -> URLRequest { buildDefaultRequest(.get, for: url, with: token) }

  static func post(
    for url: URL,
    body: Data,
    with token: String? = nil
  ) -> URLRequest {
    var request = buildDefaultRequest(.post, for: url, with: token)
    request.httpBody = body
    return request
  }

  private static func buildDefaultRequest(
    _ method: HttpMethod,
    for url: URL,
    with token: String? = nil) -> URLRequest {
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.addValue("", forHTTPHeaderField: "apikey")

      if let token = token {
        request.addValue(token, forHTTPHeaderField: "token")
      }

      return request
    }
}

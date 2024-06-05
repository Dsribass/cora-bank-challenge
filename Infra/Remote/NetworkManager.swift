import Foundation
import Combine

protocol NetworkRequest {
  func get(for url: URL, shouldWaitForPriorityRequest: Bool) -> AnyPublisher<Data, Error>

  func post(
    for url: URL, body: Data, shouldWaitForPriorityRequest: Bool
  ) -> AnyPublisher<Data, Error>
}

public class NetworkManager: NetworkRequest {
  private enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
  }
  
  public init(session: URLSession, apiKey: String) {
    self.apiKey = apiKey
    self.session = session
  }

  private let session: URLSession
  private let apiKey: String
  private var token: String?

  func setToken(_ token: String) {
    self.token = token
  }

  func unsetToken() {
    self.token = nil
  }

  func get(for url: URL, shouldWaitForPriorityRequest: Bool = true) -> AnyPublisher<Data, Error> {
    let request = buildDefaultRequest(.get, for: url)
    return fetchData(for: request, shouldWaitForPriorityRequest: shouldWaitForPriorityRequest)
  }

  func post(
    for url: URL,
    body: Data,
    shouldWaitForPriorityRequest: Bool = true
  ) -> AnyPublisher<Data, Error> {
    var request = buildDefaultRequest(.post, for: url)
    request.httpBody = body

    return fetchData(for: request, shouldWaitForPriorityRequest: shouldWaitForPriorityRequest)
  }

  // TODO: Implement other methods if necessary

  private func buildDefaultRequest(
    _ method: HttpMethod,
    for url: URL
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    request.setValue(
      "application/json; charset=utf-8",
      forHTTPHeaderField: "Content-Type")
    request.setValue(
      "application/json; charset=utf-8",
      forHTTPHeaderField: "Accept")

    request.addValue(apiKey, forHTTPHeaderField: "apikey")

    if let token = token {
      request.addValue(token, forHTTPHeaderField: "token")
    }

    return request
  }

  private func fetchData(
    for request: URLRequest,
    shouldWaitForPriorityRequest: Bool
  ) -> AnyPublisher<Data, Error> {
    taskQueuePublisher
      .filter { _ in shouldWaitForPriorityRequest ? !self.isRequestQueueBlocked() : true }
      .first()
      .flatMap { _ in self.session
          .dataTaskPublisher(for: request)
          .tryMapToData()
      }
      .eraseToAnyPublisher()
  }

  // MARK: - PrioriotyTaskStatus

  public enum PrioriotyTaskStatus {
    case blocked, normal
  }

  private var taskQueuePublisher = CurrentValueSubject<PrioriotyTaskStatus, Never>(.normal)

  private func isRequestQueueBlocked() -> Bool {
    switch taskQueuePublisher.value {
    case .blocked: return true
    default: return false
    }
  }

  func blockQueue() {
    taskQueuePublisher.send(.blocked)
  }

  func unlockQueue() {
    taskQueuePublisher.send(.normal)
  }
}

private extension URLRequest {
  func debug() {
    print("\(self.httpMethod!) \(self.url!)")
    print("Headers:")
    print(self.allHTTPHeaderFields!)
    print("Body:")
    print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
  }
}

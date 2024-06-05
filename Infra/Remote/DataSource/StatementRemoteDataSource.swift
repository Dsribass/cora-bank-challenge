import Foundation
import Combine

public class StatementRemoteDataSource {
  public init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  private let networkManager: NetworkManager

  func getStatementList() -> AnyPublisher<StatementRemoteModel.Response, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return networkManager.get(for: URLBuilder.list())
      .decode(type: StatementRemoteModel.Response.self, decoder: decoder)
      .eraseToAnyPublisher()
  }
}

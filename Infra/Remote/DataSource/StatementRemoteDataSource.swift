import Foundation
import Combine

public class StatementRemoteDataSource {
  public init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  private let networkManager: NetworkManager

  func getStatementDetail(id: String) -> AnyPublisher<StatementRemoteModel.Response, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return networkManager.get(for: URLBuilder.detail(id: id))
      .decode(type: StatementRemoteModel.Response.self, decoder: decoder)
      .eraseToAnyPublisher()
  }

  func getStatementList() -> AnyPublisher<StatementSummaryRemoteModel.Response, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return networkManager.get(for: URLBuilder.list())
      .decode(type: StatementSummaryRemoteModel.Response.self, decoder: decoder)
      .eraseToAnyPublisher()
  }
}

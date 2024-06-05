import Combine

public protocol UseCase {
  associatedtype Req
  associatedtype Res

  func execute(_ req: Req) -> AnyPublisher<Res, DomainError>
  func runBlock(_ req: Req) -> AnyPublisher<Res, DomainError>
}

extension UseCase {
  public func execute(_ req: Req) -> AnyPublisher<Res, DomainError> {
    runBlock(req)
      .mapError { error in
        print("DomainError: \(error.localizedDescription)")

        return error
      }
      .eraseToAnyPublisher()
  }
}

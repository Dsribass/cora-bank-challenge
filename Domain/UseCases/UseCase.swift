import Combine

/// The `UseCase` protocol is the base for all use cases.
///
/// Use cases are the bridge between the presentation layer and the data layer.
/// They are responsible for executing business rules and logic.
///
/// It provides two methods:
/// - execute: This method is the one that should be called by the presentation layer.
/// It will execute the runBlock method and map any error to DomainError.
/// - runBlock: This method is the one that should be implemented by the concrete use case.
/// It should contain the business rules and logic.
///
/// Additionally, it provides two associated types:
/// - Req: The input parameter.
/// - Res: The output parameter.
///
/// Example of usage:
/// ```
/// struct GetUsersUseCase: UseCase {
///   func runBlock(_ req: Void) -> AnyPublisher<[User], DomainError> {
///     return userRepository.getUsers()
///   }
/// }
///
/// let useCase = GetUsersUseCase()
/// useCase.execute(())
/// ```
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

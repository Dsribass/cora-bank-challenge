import Combine

// TODO(any): Implement authenticate usecase
public final class AuthenticateUser {
  public struct Request {
    public init(cpf: String, password: String) {
      self.cpf = cpf
      self.password = password
    }

    public let cpf: String
    public let password: String
  }

  public init() {}

  public func execute(_ req: Request) {}
}

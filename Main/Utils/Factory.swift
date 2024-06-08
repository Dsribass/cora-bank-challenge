import Foundation
import Domain
import Infra
import Combine

enum Factory {
  // TODO(any): Refactor
  static let authPublisher = AuthStatePublisher(nil)
  private static let networkManager = NetworkManager(
    session: URLSession.shared,
    apiKey: EnvironmentVariables.apikey)

  enum Infra {
    static func makeAuthRDS() -> AuthRemoteDataSource { AuthRemoteDataSource(networkManager: networkManager) }

    static func makeStatementRDS() -> StatementRemoteDataSource { StatementRemoteDataSource(networkManager: networkManager) }

    static func makeAuthLDS() -> AuthLocalDataSource { AuthLocalDataSource(defaults: UserDefaults.standard) }

    static func makeAuthRepository() -> AuthRepository {
      DefaultAuthRepository(authRDS: makeAuthRDS(), authLDS: makeAuthLDS())
    }

    static func makeStatementRepository() -> StatementRepository {
      DefaultStatementRepository(statementRDS: makeStatementRDS())
    }
  }

  enum Domain {
    static func makeValidateCpf() -> ValidateCpf { ValidateCpf() }

    static func makeAuthenticateUser() -> AuthenticateUser {
      AuthenticateUser(
        authRepository: Infra.makeAuthRepository(),
        authPublisher: Factory.authPublisher)
    }

    static func makeLoadAuthState() -> LoadAuthState {
      LoadAuthState(
        authRepository: Infra.makeAuthRepository(),
        authPublisher: Factory.authPublisher)
    }

    static func makeLogOutUser() -> LogOutUser {
      LogOutUser(
        authRepository: Infra.makeAuthRepository(),
        authPublisher: Factory.authPublisher)
    }

    static func makeRefreshToken() -> RefreshToken {
      RefreshToken(authRepository: Infra.makeAuthRepository())
    }

    static func makeGetStatementList() -> GetStatementList {
      GetStatementList(statementRepository: Infra.makeStatementRepository())
    }

    static func makeGetStatementDetail() -> GetStatementDetail {
      GetStatementDetail(statementRepository: Infra.makeStatementRepository())
    }
  }

  enum ViewModel {
    static func makeIdentificationVM() -> IdentificationViewModel {
      IdentificationViewModel(validateCpf: Domain.makeValidateCpf())
    }

    static func makePasswordVM(cpf: String) -> PasswordViewModel {
      PasswordViewModel(authenticate: Domain.makeAuthenticateUser(), cpf: cpf)
    }

    static func makeStatementListVM() -> StatementListViewModel {
      StatementListViewModel(getStatementList: Domain.makeGetStatementList())
    }
  }

  enum ViewController {
    static func makeIntroVC(router: IntroViewRouter) -> IntroViewController {
      IntroViewController(router: router)
    }

    static func makeIdentificationVC(router: IdentificationViewRouter) -> IdentificationViewController {
      IdentificationViewController(viewModel: ViewModel.makeIdentificationVM(), router: router)
    }

    static func makePasswordVC(cpf: String) -> PasswordViewController {
      PasswordViewController(viewModel: ViewModel.makePasswordVM(cpf: cpf))
    }

    static func makeStatementListVC() -> StatementListViewController {
      StatementListViewController(viewModel: ViewModel.makeStatementListVM())
    }
  }
}

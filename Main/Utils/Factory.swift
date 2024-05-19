import Foundation
import Domain
import Infra

enum Factory {
  enum Infra {
    static func makeAuthRDS() -> AuthRemoteDataSource { AuthRemoteDataSource(session: URLSession.shared) }

    static func makeAuthLDS() -> AuthLocalDataSource { AuthLocalDataSource(defaults: UserDefaults.standard) }

    static func makeAuthRepository() -> AuthRepositoryProtocol {
      AuthRepository(authRDS: makeAuthRDS(), authLDS: makeAuthLDS())
    }
  }

  enum Domain {
    static func makeValidateCpf() -> ValidateCpf { ValidateCpf() }

    static func makeAuthenticateUser() -> AuthenticateUser { AuthenticateUser(authRepository: Infra.makeAuthRepository()) }
  }

  enum ViewModel {
    static func makeIdentificationVM() -> IdentificationViewModel {
      IdentificationViewModel(validateCpf: Domain.makeValidateCpf())
    }

    static func makePasswordVM(cpf: String) -> PasswordViewModel {
      PasswordViewModel(authenticate: Domain.makeAuthenticateUser(), cpf: cpf)
    }
  }

  enum ViewController {
    static func makeIntroVC(router: IntroViewRouter) -> IntroViewController {
      IntroViewController(router: router)
    }

    static func makeIdentificationVC(router: IdentificationViewRouter) -> IdentificationViewController {
      IdentificationViewController(viewModel: ViewModel.makeIdentificationVM(), router: router)
    }

    static func makePasswordVC(cpf: String, router: PasswordViewRouter) -> PasswordViewController {
      PasswordViewController(viewModel: ViewModel.makePasswordVM(cpf: cpf), router: router)
    }
  }
}

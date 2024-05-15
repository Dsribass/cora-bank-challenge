import Domain

enum Factory {
  enum Domain {
    static func makeValidateCpf() -> ValidateCpf { ValidateCpf() }
    static func makeAuthenticateUser() -> AuthenticateUser { AuthenticateUser() }
  }

  enum ViewModel {
    static func makeIdentificationVM() -> IdentificationViewModel {
      IdentificationViewModel(validateCpf: Domain.makeValidateCpf())
    }

    static func makePasswordVM() -> PasswordViewModel {
      PasswordViewModel(authenticate: Domain.makeAuthenticateUser())
    }
  }

  enum ViewController {
    static func makeIntroVC(router: IntroViewRouter) -> IntroViewController {
      IntroViewController(router: router)
    }

    static func makeIdentificationVC(router: IdentificationViewRouter) -> IdentificationViewController {
      IdentificationViewController(viewModel: ViewModel.makeIdentificationVM(), router: router)
    }

    static func makePasswordVC() -> PasswordViewController {
      PasswordViewController(viewModel: ViewModel.makePasswordVM())
    }
  }
}

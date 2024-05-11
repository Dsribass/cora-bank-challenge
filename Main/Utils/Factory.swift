import Domain

enum Factory {
  enum Domain {
    static func makeValidateCpfUC() -> ValidateCpfUseCase {
      ValidateCpfUseCase()
    }
  }

  enum ViewModel {
    static func makeIdentificationVM() -> IdentificationViewModel {
      IdentificationViewModel(validateCpf: Domain.makeValidateCpfUC())
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
      PasswordViewController()
    }
  }
}

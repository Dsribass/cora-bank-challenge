import UIKit

enum Strings {
  enum Error {
    static let title = String(localized: "ErrorTitle")
    static let message = String(localized: "ErrorMessage")
    static let button = String(localized: "ErrorButton")
  }

  enum Intro {
    static let title = String(localized: "IntroPageTitle")
    static let subtitle = String(localized: "IntroPageSubtitle")
    static let description = String(localized: "IntroPageDescription")
    static let primaryButton = String(localized: "IntroPagePrimaryButton")
    static let secondaryButton = String(localized: "IntroPageSecondaryButton")
  }

  enum Login {
    static let navBarTitle = String(localized: "LoginNavBarTitle")
    static let nextStepButton = String(localized: "LoginNextStepButton")
  }

  enum Identification {
    static let pageGreetings = String(localized: "IdentificationPageGreetings")
    static let cpf = String(localized: "IdentificationPageCpf")
    static let cpfInvalid = String(localized: "IdentificationPageCpfInvalid")
    static let cpfEmpty = String(localized: "IdentificationPageCpfEmpty")
  }

  enum Password {
    static let title = String(localized: "PasswordPageTitle")
    static let forgotPassword = String(localized: "PasswordPageForgotPassword")
    static let error = String(localized: "PasswordPageError")
    static let invalid = String(localized: "PasswordPageInvalidInput")
  }

  enum BankStatement {
    static let title = String(localized: "BankStatementTitle")
    static let firstFilterTab = String(localized: "BankStatementFilterTabOne")
    static let secondFilterTab = String(localized: "BankStatementFilterTabTwo")
    static let thirdFilterTab = String(localized: "BankStatementFilterTabThree")
    static let fourthFilterTab = String(localized: "BankStatementFilterTabFour")
  }

  enum StatementDetail {
    static let navBarTitle = String(localized: "StatementDetailNavBarTitle")
    static let title = String(localized: "StatementDetailTitle")
    static let amountSection = String(localized: "StatementDetailAmountSection")
    static let dateSection = String(localized: "StatementDetailDateSection")
    static let senderSection = String(localized: "StatementDetailSenderSection")
    static let receiverSection = String(localized: "StatementDetailReceiverSection")
    static let descriptionSection = String(localized: "StatementDetailDescriptionSection")
    static let button = String(localized: "StatementDetailButton")

    static func bankInfo(agency: String, account: String) -> String {
      "\(String(localized: "StatementDetailAgency")) \(agency) - \(String(localized: "StatementDetailAccount")) \(account)"
    }
  }
}


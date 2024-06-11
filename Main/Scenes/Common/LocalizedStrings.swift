import UIKit

enum LocalizedStrings {
  static let introTitle = String(localized: "IntroPageTitle")
  static let introSubtitle = String(localized: "IntroPageSubtitle")
  static let introDescription = String(localized: "IntroPageDescription")
  static let introPrimaryButton = String(localized: "IntroPagePrimaryButton")
  static let introSecondaryButton = String(localized: "IntroPageSecondaryButton")
  static let loginNavBarTitle = String(localized: "LoginNavBarTitle")
  static let loginNextStepButton = String(localized: "LoginNextStepButton")
  static let identificationPageGreetings = String(localized: "IdentificationPageGreetings")
  static let identificationCpf = String(localized: "IdentificationPageCpf")
  static let identificationCpfInvalid = String(localized: "IdentificationPageCpfInvalid")
  static let identificationCpfEmpty = String(localized: "IdentificationPageCpfEmpty")
  static let passwordTitle = String(localized: "PasswordPageTitle")
  static let passwordForgotPassword = String(localized: "PasswordPageForgotPassword")
  static let passwordInvalid = String(localized: "PasswordPageInvalidInput")
  static let loginError = String(localized: "PasswordPageError")
  static let bankStatementTitle = String(localized: "BankStatementTitle")
  static let bankStatementFirstFilterTab = String(localized: "BankStatementFilterTabOne")
  static let bankStatementSecondFilterTab = String(localized: "BankStatementFilterTabTwo")
  static let bankStatementThirdFilterTab = String(localized: "BankStatementFilterTabThree")
  static let bankStatementFourthFilterTab
  = String(localized: "BankStatementFilterTabFour")
  static let statementDetailNavBarTitle = String(localized: "StatementDetailNavBarTitle")
  static let statementDetailTitle = String(localized: "StatementDetailTitle")
  static let statementDetailAmountSection = String(localized: "StatementDetailAmountSection")
  static let statementDetailDateSection = String(localized: "StatementDetailDateSection")
  static let statementDetailSenderSection = String(localized: "StatementDetailSenderSection")
  static let statementDetailReceiverSection = String(localized: "StatementDetailReceiverSection")
  static let statementDetailDescriptionSection = String(localized: "StatementDetailDescriptionSection")
  static let statementDetailButton = String(localized: "StatementDetailButton")

  static func statementDetailBankInfo(agency: String, account: String) -> String {
    "\(String(localized: "StatementDetailAgency")) \(agency) - \(String(localized: "StatementDetailAccount")) \(account)"
  }
}

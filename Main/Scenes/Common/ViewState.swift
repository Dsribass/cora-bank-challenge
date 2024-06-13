import UIKit

protocol ViewState {
  associatedtype Data
  func showLoading()
  func showSuccess(_ data: Data)
  func showError(message: String?, _ onRetry: @escaping () -> Void)
}

import UIKit

class CoraNavigationController: UINavigationController {
  init() {
    super.init(nibName: nil, bundle: nil)
    setupAppearence()
  }

  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    setupAppearence()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupAppearence() {
    let appearence = UINavigationBarAppearance()
    appearence.configureWithDefaultBackground()

    appearence.backgroundColor = .Cora.gray4
    appearence.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor : UIColor.Cora.gray1,
      NSAttributedString.Key.font : UIFont.coraFont(for: .body2, weight: .regular)
    ]
    appearence.setBackIndicatorImage(
      UIImage(named: .icChevronLeft),
      transitionMaskImage: UIImage(named: .icChevronLeft))

    self.navigationBar.standardAppearance = appearence
    self.navigationBar.compactAppearance = appearence
    self.navigationBar.scrollEdgeAppearance = appearence
    self.navigationBar.tintColor = .Cora.primaryColor    
  }
}

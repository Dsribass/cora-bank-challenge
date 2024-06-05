import UIKit

class LoadingViewController: SceneViewController<LoadingView> {}

class LoadingView: UIViewCodable {
  lazy var spinner = UIActivityIndicatorView(style: .large)

  override func setupLayout() {
    backgroundColor = .Cora.white
    spinner.color = .Cora.primaryColor
    spinner.startAnimating()
  }

  override func setupSubviews() {
    addSubview(spinner)
  }

  override func setupConstraints() {
    spinner.makeConstraints { view in
      [
        view.centerXAnchor.constraint(equalTo: centerXAnchor),
        view.centerYAnchor.constraint(equalTo: centerYAnchor),
      ]
    }
  }
}

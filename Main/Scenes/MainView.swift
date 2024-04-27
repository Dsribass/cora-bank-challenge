import UIKit

class MainView: UIViewCodable {
  private lazy var title: UILabel = {
    let label = UILabel()
    label.text = "Hello World"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

  override func setupSubviews() {
    addSubview(title)
  }

  override func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor),
      title.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
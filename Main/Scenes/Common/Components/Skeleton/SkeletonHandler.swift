import UIKit

protocol SkeletonHandler: AnyObject {
  var skeletonViews: [(view: UIView, layer: CAGradientLayer)] { get set }
}

extension SkeletonHandler where Self: UIViewController {
  func setupSkeletonViews(_ views: [UIView]) {
    skeletonViews.removeAll()
    skeletonViews.append(contentsOf: views.map {
      (view: $0, layer: CAGradientLayer())
    })
  }

  func showSkeleton() {
    // Update subviews layout(constraints)
    view.setNeedsLayout()
    view.layoutIfNeeded()

    skeletonViews.forEach { (view: UIView, layer: CAGradientLayer) in
      layer.frame = view.bounds
      layer.cornerRadius = 4.0
      layer.startPoint = CGPoint(x: 0, y: 0.5)
      layer.endPoint = CGPoint(x: 1, y: 0.5)
      view.layer.addSublayer(layer)

      let titleGroup = makeAnimationGroup()
      titleGroup.beginTime = 0.0
      layer.add(titleGroup, forKey: "backgroundColor")
    }
  }

  func hideSkeleton() {
    skeletonViews.forEach { (view, layer) in
      layer.removeFromSuperlayer()
    }
  }

  func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
    let animDuration: CFTimeInterval = 1.5
    let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
    anim1.fromValue = UIColor.gradientLightGrey.cgColor
    anim1.toValue = UIColor.gradientDarkGrey.cgColor
    anim1.duration = animDuration
    anim1.beginTime = 0.0

    let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
    anim2.fromValue = UIColor.gradientDarkGrey.cgColor
    anim2.toValue = UIColor.gradientLightGrey.cgColor
    anim2.duration = animDuration
    anim2.beginTime = anim1.beginTime + anim1.duration

    let group = CAAnimationGroup()
    group.animations = [anim1, anim2]
    group.repeatCount = .greatestFiniteMagnitude
    group.duration = anim2.beginTime + anim2.duration
    group.isRemovedOnCompletion = false

    if let previousGroup = previousGroup {
      group.beginTime = previousGroup.beginTime + 0.33
    }

    return group
  }
}

private extension UIColor {
  static var gradientDarkGrey: UIColor {
    return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
  }

  static var gradientLightGrey: UIColor {
    return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
  }
}

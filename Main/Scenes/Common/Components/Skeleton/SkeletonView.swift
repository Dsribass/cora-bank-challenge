import UIKit

class SkeletonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeletonLayer()
    }

    private func setupSkeletonLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.75, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 5

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "shimmer")
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

extension UIView {
    private struct SkeletonKeys {
        static var skeletonView = "skeletonView"
    }

    private var skeletonView: SkeletonView? {
        get {
            return objc_getAssociatedObject(self, SkeletonKeys.skeletonView) as? SkeletonView
        }
        set {
            objc_setAssociatedObject(self, SkeletonKeys.skeletonView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showSkeleton() {
        if skeletonView == nil {
            let skeleton = SkeletonView(frame: bounds)
            skeletonView = skeleton
            addSubview(skeleton)
            skeleton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                skeleton.leadingAnchor.constraint(equalTo: leadingAnchor),
                skeleton.trailingAnchor.constraint(equalTo: trailingAnchor),
                skeleton.topAnchor.constraint(equalTo: topAnchor),
                skeleton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        subviews.forEach { $0.showSkeleton() }
    }

    func hideSkeleton() {
        skeletonView?.removeFromSuperview()
        skeletonView = nil
        subviews.forEach { $0.hideSkeleton() }
    }
}

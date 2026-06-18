import UIKit

final class RingSpinnerView: UIView {

    private let trackLayer = CAShapeLayer()
    private let ringLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear

        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.15).cgColor
        trackLayer.lineWidth = 4
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.colorPrimary.cgColor
        ringLayer.lineWidth = 4
        ringLayer.lineCap = .round
        ringLayer.strokeStart = 0
        ringLayer.strokeEnd = 0.75
        layer.addSublayer(ringLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - 4) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 1.5, clockwise: true)
        trackLayer.path = path.cgPath
        ringLayer.path = path.cgPath
        trackLayer.frame = bounds
        ringLayer.frame = bounds
    }

    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 0.9
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        ringLayer.add(rotation, forKey: "rotation")
    }

    func stopAnimating() {
        ringLayer.removeAllAnimations()
    }
}

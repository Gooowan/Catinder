import UIKit

// some ideas taken from here - https://youtu.be/hyPvSjuZ5PI?si=J2SEDKHKfhqpPMY-
// and from here - https://youtu.be/__pzeIpof1s?si=PXY4pMgqtqaW3Xi9

class SpinnerView: UIView {

    private let rotationTime: Double = 1.0
    private let spinnerLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinnerLayer()
        animateSpinner()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSpinnerLayer() {
        let radius: CGFloat = 25.0
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        spinnerLayer.path = circularPath.cgPath
        spinnerLayer.strokeColor = UIColor.gray.cgColor
        spinnerLayer.lineWidth = 3.0
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineCap = .round
        spinnerLayer.strokeEnd = 0.25

        self.layer.addSublayer(spinnerLayer)
    }

    private func animateSpinner() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = rotationTime
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity

        spinnerLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        animateSpinner()
    }
}

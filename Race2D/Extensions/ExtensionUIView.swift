import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
    
    func dropshadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 4

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath

        layer.shouldRasterize = true
    }
    
    func addParalaxEffect(amount: Int = 20) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }

    
}

//
//  SwiftUIView.swift
//  
//
//  Created by Alisa Mylnikova on 31.03.2023.
//

import UIKit

// MARK: - UIView Extensions
public extension UIView {
    
    /// Get the size of a view after layout
    func getSize(completion: @escaping (CGSize) -> Void) {
        DispatchQueue.main.async {
            completion(self.bounds.size)
        }
    }
    
    /// Add multiple subviews at once
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    /// Remove all subviews
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// Apply corner radius
    func cornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Apply shadow
    func shadow(color: UIColor = .black, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 2), opacity: Float = 0.3) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

// MARK: - Collection Extensions
public extension Collection where Element == CGPoint {
    
    subscript (safe index: Index) -> CGPoint {
        return indices.contains(index) ? self[index] : .zero
    }
}

public extension Collection where Element == CGRect {
    
    subscript (safe index: Index) -> CGRect {
        return indices.contains(index) ? self[index] : .zero
    }
}

// MARK: - Animation Utilities
public class AnimationUtility {
    
    public static func spring(
        duration: TimeInterval = 0.4,
        damping: CGFloat = 0.8,
        velocity: CGFloat = 0.5,
        delay: TimeInterval = 0,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: .curveEaseOut,
            animations: animations,
            completion: completion
        )
    }
    
    public static func easeInOut(
        duration: TimeInterval = 0.4,
        delay: TimeInterval = 0,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: animations,
            completion: completion
        )
    }
}

// MARK: - Math Utilities
public class MathUtility {
    
    /// Round CGSize to two decimal places
    public static func roundToTwoDigits(_ size: CGSize) -> CGSize {
        CGSize(
            width: ceil(size.width * 100) / 100,
            height: ceil(size.height * 100) / 100
        )
    }
    
    /// Calculate distance between two points
    public static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    /// Calculate angle between two points
    public static func angle(from point1: CGPoint, to point2: CGPoint) -> Double {
        let dx = Double(point2.x - point1.x)
        let dy = Double(point2.y - point1.y)
        return atan2(dy, dx)
    }
    
    /// Convert degrees to radians
    public static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    /// Convert radians to degrees
    public static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }
}

// MARK: - Button Factory
public class ButtonFactory {
    
    public static func createFloatingButton(
        systemName: String,
        size: CGFloat = 50,
        backgroundColor: UIColor = .systemBlue,
        tintColor: UIColor = .white
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.backgroundColor = backgroundColor
        button.tintColor = tintColor
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        button.layer.cornerRadius = size / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        return button
    }
    
    public static func createSubmenuButton(
        systemName: String,
        size: CGFloat = 40,
        backgroundColor: UIColor = .systemGray,
        tintColor: UIColor = .white
    ) -> UIButton {
        return createFloatingButton(
            systemName: systemName,
            size: size,
            backgroundColor: backgroundColor,
            tintColor: tintColor
        )
    }
}

// MARK: - Layout Calculator
public class LayoutCalculator {
    
    /// Calculate positions for straight line layout
    public static func calculateStraightLayout(
        direction: FloatingDirection,
        spacing: CGFloat,
        buttonSize: CGFloat,
        submenuButtonSize: CGFloat,
        count: Int,
        centerPoint: CGPoint
    ) -> [CGPoint] {
        var positions: [CGPoint] = []
        var currentPosition = centerPoint
        
        for _ in 0..<count {
            let buttonSpacing = (buttonSize + submenuButtonSize) / 2 + spacing
            
            switch direction {
            case .left:
                currentPosition.x -= buttonSpacing
            case .right:
                currentPosition.x += buttonSpacing
            case .top:
                currentPosition.y -= buttonSpacing
            case .bottom:
                currentPosition.y += buttonSpacing
            }
            
            positions.append(currentPosition)
        }
        
        return positions
    }
    
    /// Calculate positions for circle layout
    public static func calculateCircleLayout(
        startAngle: Double,
        endAngle: Double,
        radius: Double,
        count: Int,
        centerPoint: CGPoint,
        layoutDirection: FloatingLayoutDirection
    ) -> [CGPoint] {
        var positions: [CGPoint] = []
        
        for i in 0..<count {
            let increment = (endAngle - startAngle) / Double(count - 1) * Double(i)
            let angle = layoutDirection == .clockwise ? startAngle + increment : startAngle - increment
            
            let x = centerPoint.x + CGFloat(radius * cos(angle))
            let y = centerPoint.y + CGFloat(radius * sin(angle))
            
            positions.append(CGPoint(x: x, y: y))
        }
        
        return positions
    }
}

// MARK: - Notification Names
public extension Notification.Name {
    static let floatingButtonDidOpen = Notification.Name("floatingButtonDidOpen")
    static let floatingButtonDidClose = Notification.Name("floatingButtonDidClose")
    static let floatingButtonDidTapSubmenu = Notification.Name("floatingButtonDidTapSubmenu")
}

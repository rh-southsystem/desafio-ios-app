//
//  Constraint.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import UIKit

public typealias AnchorX = (anchor: NSLayoutXAxisAnchor, distance: CGFloat)
public typealias AnchorY = (anchor: NSLayoutYAxisAnchor, distance: CGFloat)
public typealias AnchorSize = (anchor: NSLayoutDimension, distance: CGFloat, multiplier: CGFloat)

public final class Constraints {
    public var centerX: NSLayoutConstraint? { didSet { centerX?.isActive = true } }
    public var centerY: NSLayoutConstraint? { didSet { centerY?.isActive = true } }
    public var top: NSLayoutConstraint? { didSet { top?.isActive = true } }
    public var leading: NSLayoutConstraint? { didSet { leading?.isActive = true } }
    public var trailing: NSLayoutConstraint? { didSet { trailing?.isActive = true } }
    public var left: NSLayoutConstraint? { didSet { left?.isActive = true } }
    public var right: NSLayoutConstraint? { didSet { right?.isActive = true } }
    public var bottom: NSLayoutConstraint? { didSet { bottom?.isActive = true } }
    public var width: NSLayoutConstraint? { didSet { width?.isActive = true } }
    public var height: NSLayoutConstraint? { didSet { height?.isActive = true } }
    public var anchorWidth: NSLayoutConstraint? { didSet { anchorWidth?.isActive = true } }
    public var anchorHeight: NSLayoutConstraint? { didSet { anchorHeight?.isActive = true } }
    
    public init (
        centerX: NSLayoutConstraint? = nil,
        centerY: NSLayoutConstraint? = nil,
        top: NSLayoutConstraint? = nil,
        leading: NSLayoutConstraint? = nil,
        trailing: NSLayoutConstraint? = nil,
        left: NSLayoutConstraint? = nil,
        right: NSLayoutConstraint? = nil,
        bottom: NSLayoutConstraint? = nil,
        width: NSLayoutConstraint? = nil,
        height: NSLayoutConstraint? = nil,
        anchorWidth: NSLayoutConstraint? = nil,
        anchorHeight: NSLayoutConstraint? = nil
        ) {
        self.centerX = centerX
        self.centerY = centerY
        self.top = top
        self.leading = leading
        self.trailing = trailing
        self.left = left
        self.right = right
        self.bottom = bottom
        self.width = width
        self.height = height
        self.anchorWidth = anchorWidth
        self.anchorHeight = anchorHeight
        
        centerX?.isActive = true
        centerY?.isActive = true
        top?.isActive = true
        leading?.isActive = true
        trailing?.isActive = true
        left?.isActive = true
        right?.isActive = true
        bottom?.isActive = true
        width?.isActive = true
        height?.isActive = true
        anchorWidth?.isActive = true
        anchorHeight?.isActive = true
    }
    
    public func deactivate() {
        deactivate(&centerX)
        deactivate(&centerY)
        deactivate(&top)
        deactivate(&leading)
        deactivate(&trailing)
        deactivate(&left)
        deactivate(&right)
        deactivate(&bottom)
        deactivate(&width)
        deactivate(&height)
        deactivate(&anchorWidth)
        deactivate(&anchorHeight)
    }
    
    fileprivate func deactivate(_ constraint: inout NSLayoutConstraint?) {
        constraint?.isActive = false
        constraint = nil
    }
}

extension UIView {
    fileprivate func bind(anchorX: AnchorX?, selfAnchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint? {
        guard let anchorX = anchorX else { return nil }
        return anchorX.anchor.constraint(
            equalTo: selfAnchor,
            constant: anchorX.distance
        )
    }
    
    fileprivate func bind(anchorY: AnchorY?, selfAnchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint? {
        guard let anchorY = anchorY else { return nil }
        return anchorY.anchor.constraint(
            equalTo: selfAnchor,
            constant: anchorY.distance
        )
    }
    
    fileprivate func bind(anchorSize: AnchorSize?, selfAnchor: NSLayoutDimension) -> NSLayoutConstraint? {
        guard let anchorSize = anchorSize else { return nil }
        return selfAnchor.constraint(
            equalTo: anchorSize.anchor,
            multiplier: anchorSize.multiplier,
            constant: anchorSize.distance
        )
    }
    
    fileprivate func bind(size: CGFloat?, selfAnchor: NSLayoutDimension) -> NSLayoutConstraint? {
        guard let size = size else { return nil }
        return selfAnchor.constraint(equalToConstant: size)
    }
    
    @discardableResult
    public func anchor (
        centerX: AnchorX?  = nil,
        centerY: AnchorY?  = nil,
        top: AnchorY?  = nil,
        leading: AnchorX?  = nil,
        trailing: AnchorX?  = nil,
        left: AnchorX?  = nil,
        right: AnchorX?  = nil,
        bottom: AnchorY?  = nil,
        width: CGFloat?  = nil,
        height: CGFloat?  = nil,
        anchorWidth: AnchorSize? = nil,
        anchorHeight: AnchorSize? = nil
        ) -> Constraints {
        guard width == nil || anchorWidth == nil else {
            fatalError("Can't set parameters width and anchorWidth at the same call")
        }
        
        guard height == nil || anchorHeight == nil else {
            fatalError("Can't set parameters height and anchorHeight at the same call")
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var newTop: AnchorY?
        if let top = top {
            newTop = top
            newTop?.distance *= -1
        }
        
        var newLeading: AnchorX?
        if let leading = leading {
            newLeading = leading
            newLeading?.distance *= -1
        }
        
        var newLeft: AnchorX?
        if let left = left {
            newLeft = left
            newLeft?.distance *= -1
        }
        
        return Constraints(
            centerX: bind(anchorX: centerX, selfAnchor: centerXAnchor),
            centerY: bind(anchorY: centerY, selfAnchor: centerYAnchor),
            top: bind(anchorY: newTop, selfAnchor: topAnchor),
            leading: bind(anchorX: newLeading, selfAnchor: leadingAnchor),
            trailing: bind(anchorX: trailing, selfAnchor: trailingAnchor),
            left: bind(anchorX: newLeft, selfAnchor: leftAnchor),
            right: bind(anchorX: right, selfAnchor: rightAnchor),
            bottom: bind(anchorY: bottom, selfAnchor: bottomAnchor),
            width: bind(size: width, selfAnchor: widthAnchor),
            height: bind(size: height, selfAnchor: heightAnchor),
            anchorWidth: bind(anchorSize: anchorWidth, selfAnchor: widthAnchor),
            anchorHeight: bind(anchorSize: anchorHeight, selfAnchor: heightAnchor)
        )
    }
    
    @discardableResult
    public func autoFill(to view: UIView, insets: UIEdgeInsets = .zero, withSafeArea: Bool = true) -> Constraints {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        guard #available(iOS 11.0, *), withSafeArea else {
            return anchor(
                top: (view.topAnchor, insets.top),
                left: (view.leftAnchor, insets.left),
                right: (view.rightAnchor, insets.right),
                bottom: (view.bottomAnchor, insets.bottom)
            )
        }
        
        return anchor(
            top: (view.safeAreaLayoutGuide.topAnchor, insets.top),
            left: (view.safeAreaLayoutGuide.leftAnchor, insets.left),
            right: (view.safeAreaLayoutGuide.rightAnchor, insets.right),
            bottom: (view.safeAreaLayoutGuide.bottomAnchor, insets.bottom)
        )
    }
    
    @discardableResult
    public func autoCenter(to view: UIView, offset: CGPoint = .zero) -> Constraints {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return anchor(
            centerX: (view.centerXAnchor, offset.x),
            centerY: (view.centerYAnchor, offset.y)
        )
    }
    
    @discardableResult
    public func autoSize(with size: CGSize) -> Constraints {
        return anchor(
            width: size.width,
            height: size.height
        )
    }
    
    @discardableResult
    public func autoSize(to view: UIView, offset: CGPoint = .zero, multiplier: CGSize = CGSize(width: 1, height: 1)) -> Constraints {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return anchor(
            anchorWidth: (view.widthAnchor, offset.x, multiplier.width),
            anchorHeight: (view.heightAnchor, offset.y, multiplier.height)
        )
    }
    
    @discardableResult
    public func fillSuperview(insets: UIEdgeInsets = .zero, withSafeArea: Bool = true) -> Constraints {
        guard let superview = superview else {
            fatalError("To use fillSuperview(with insets: UIEdgeInsets), view needs to be added to a superview")
        }
        
        return autoFill(to: superview, insets: insets, withSafeArea: withSafeArea)
    }
    
    @discardableResult
    public func fillSuperview(padding: CGFloat, withSafeArea: Bool = true) -> Constraints {
        guard let superview = superview else {
            fatalError("To use fillSuperview(with insets: UIEdgeInsets), view needs to be added to a superview")
        }
         
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return autoFill(to: superview, insets: insets, withSafeArea: withSafeArea)
    }
    
    @discardableResult
    public func centerSuperview(offset: CGPoint = .zero) -> Constraints {
        guard let superview = superview else {
            fatalError("To use centerSuperview(with offset: CGPoint), view needs to be added to a superview")
        }
        
        return autoCenter(to: superview, offset: offset)
    }
    
    @discardableResult
    public func bindSizeToSuperview(offset: CGPoint = .zero, multiplier: CGSize = CGSize(width: 1, height: 1)) -> Constraints {
        guard let superview = superview else {
            fatalError("To use bindSizeToSuperview(offset: CGPoint, multiplier: CGSize), view needs to be added to a superview")
        }
        
        return autoSize(to: superview, offset: offset, multiplier: multiplier)
    }
}

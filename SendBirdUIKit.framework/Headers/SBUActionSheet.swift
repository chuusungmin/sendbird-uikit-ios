
//
//  SBUActionSheet.swift
//  SendBirdUIKit
//
//  Created by Tez Park on 16/02/2020.
//  Copyright © 2020 SendBird, Inc. All rights reserved.
//

import UIKit

public typealias SBUActionSheetHandler = () -> Void

@objc public protocol SBUActionSheetDelegate: NSObjectProtocol {
    func didSelectActionSheetItem(index: Int, identifier: Int)
}

@objcMembers
public class SBUActionSheetItem: SBUCommonItem {
    var completionHandler: SBUActionSheetHandler?
     
    public init(title: String? = nil,
         color: UIColor? = nil,
         image: UIImage? = nil,
         font: UIFont? = nil,
         textAlignment: NSTextAlignment = .left,
         completionHandler: SBUActionSheetHandler? = nil) {
        
        super.init(
            title: title,
            color: color,
            image: image,
            font: font,
            textAlignment: textAlignment
        )
        self.completionHandler = completionHandler
    }
}

@objcMembers
public class SBUActionSheet {
    
    var theme: SBUComponentTheme = SBUTheme.componentTheme
    static private let shared = SBUActionSheet()
    private init() {}
    weak var delegate: SBUActionSheetDelegate?
    private var items: [SBUActionSheetItem] = []
    
    var identifier: Int = -1
    var window: UIWindow? = nil
    var baseView = UIView()
    var backgroundView = UIButton()
    
    let itemHeight: CGFloat = 56.0
    let bottomMargin: CGFloat = 48.0
    let sideMargin: CGFloat = 8.0
    let insideMargin: CGFloat = 16.0

    var prevOrientation: UIDeviceOrientation = .unknown
    
    /** [sample]
        SBUActionSheet.show(items: [SBUActionSheetItem(title: "Check", image: SBUImageSet.iconBack(tintColor: nil)),
                SBUActionSheetItem(title: "Check111", image: SBUImageSet.iconBack(tintColor: nil)),
                SBUActionSheetItem(title: "Check2222", image: SBUImageSet.iconBack(tintColor: nil))],
        cancelItem: SBUActionSheetItem(title: "Check", image: SBUImageSet.iconBack(tintColor: nil)))
     */
    /**
     [Order]
     - item1
     - item2
     - item3
     - cancel
     */
    public static func show(items: [SBUActionSheetItem],
                     cancelItem: SBUActionSheetItem,
                     identifier: Int = -1,
                     delegate: SBUActionSheetDelegate? = nil) {
        
        self.shared.show(
            items: items,
            cancelItem: cancelItem,
            identifier: identifier,
            delegate: delegate
        )
    }
    
    public static func dismiss() {
        self.shared.dismiss()
    }

    private func show(items: [SBUActionSheetItem],
                      cancelItem: SBUActionSheetItem,
                      identifier: Int = -1,
                      delegate: SBUActionSheetDelegate?) {
        
        self.dismiss()
        
        self.prevOrientation = UIDevice.current.orientation
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        self.theme = SBUTheme.componentTheme
        
        self.window = UIApplication.shared.keyWindow
        guard let window = self.window else { return }
        self.identifier = identifier
        self.delegate = delegate
        self.items = items
        
        baseView = UIView()
        backgroundView = UIButton()
        
        // Set backgroundView
        self.backgroundView.frame = window.bounds
        self.backgroundView.backgroundColor = theme.overlayColor
        self.backgroundView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        // Set items
        let totalHeight = CGFloat(items.count + 1) * itemHeight + sideMargin + bottomMargin
        let itemWidth = window.frame.width - (sideMargin * 2)
        self.baseView.frame = CGRect(
            origin: CGPoint(x: sideMargin, y: window.frame.height - totalHeight),
            size: CGSize(width: itemWidth, height: totalHeight)
        )
        
        var itemOriginY: CGFloat = 0.0
        for index in 0..<items.count {
            let button = self.makeItems(
                item: items[index],
                separator: (index != items.count-1),
                isTop: (index == 0),
                isBottom: (index == items.count-1)
            )
            button.tag = index
            var buttonFrame = button.frame
            buttonFrame.origin = CGPoint(x: 0, y: itemOriginY)
            button.frame = buttonFrame
            
            self.baseView.addSubview(button)
            
            itemOriginY += button.frame.height
        }

        itemOriginY += sideMargin

        let cancelButton = self.makeCancelItem(item: cancelItem)
        cancelButton.frame = CGRect(
            origin: CGPoint(x: 0, y: itemOriginY),
            size: cancelButton.frame.size
        )
        self.baseView.addSubview(cancelButton)

        // Add to window
        window.addSubview(self.backgroundView)
        window.addSubview(self.baseView)

        // Animation
        let baseFrame = self.baseView.frame
        self.baseView.frame = CGRect(
            origin: CGPoint(x: baseFrame.origin.x, y: window.frame.height),
            size: baseFrame.size
        )
        self.backgroundView.alpha = 0.0
        
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
        }) { completion in
            UIView.animate(withDuration: 0.2, animations: {
                self.baseView.frame = baseFrame
            })
        }
    }
    
    @objc private func dismiss() {
        for subView in self.baseView.subviews {
            subView.removeFromSuperview()
        }
        
        self.backgroundView.removeFromSuperview()
        self.baseView.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    // MARK: Make Buttons
    private func makeItems(item: SBUActionSheetItem,
                           separator: Bool,
                           isTop: Bool,
                           isBottom: Bool) -> UIButton {
        
        let width:CGFloat = (self.window?.bounds.width ?? self.baseView.frame.width)
        let itemWidth: CGFloat = width - (self.sideMargin * 2)
        let itemButton = UIButton(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: itemWidth, height: self.itemHeight)
            )
        )
        
        itemButton.setBackgroundImage(
            UIImage.from(color: theme.backgroundColor),
            for: .normal
        )
        
        itemButton.setBackgroundImage(
            UIImage.from(color: theme.highlightedColor),
            for: .highlighted
        )
        
        itemButton.addTarget(self, action: #selector(onClickActionSheetButton), for: .touchUpInside)
        
        let titleLabel = UILabel()
        let imageView = UIImageView()
        
        var textImageMargin: CGFloat = (item.textAlignment == .left) ? self.insideMargin : 0.0
        
        if let image = item.image {
            let imageSize: CGFloat = 24.0
            imageView.frame = CGRect(
                origin: CGPoint(x: itemWidth - self.insideMargin - imageSize, y: self.insideMargin),
                size: CGSize(width: imageSize, height: imageSize)
            )
            imageView.image = image
            itemButton.addSubview(imageView)
            textImageMargin = self.insideMargin
        }
        
        titleLabel.frame = CGRect(
            origin: CGPoint(x: textImageMargin, y: 0),
            size: CGSize(width: itemWidth - imageView.frame.width, height: self.itemHeight)
        )
        titleLabel.text = item.title
        titleLabel.font = item.font ?? theme.actionSheetTextFont
        titleLabel.textColor = item.color ?? theme.titleColor
        titleLabel.textAlignment = item.textAlignment
        
        itemButton.addSubview(titleLabel)
        
        if separator {
            let separatorLine = UIView(
                frame: CGRect(
                    origin: CGPoint(x: 0.0, y: itemHeight - 0.5),
                    size: CGSize(width: itemWidth, height: 0.5)
                )
            )
            separatorLine.backgroundColor = theme.separatorColor
            itemButton.addSubview(separatorLine)
        }
        
        if isTop {
            let rectShape = CAShapeLayer()
            rectShape.bounds = itemButton.frame
            rectShape.position = itemButton.center
            rectShape.path = UIBezierPath(
                roundedRect: itemButton.bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 10, height: 10))
                .cgPath
            itemButton.layer.mask = rectShape
        }
        
        if isBottom {
            let rectShape = CAShapeLayer()
            rectShape.bounds = itemButton.frame
            rectShape.position = itemButton.center
            rectShape.path = UIBezierPath(
                roundedRect: itemButton.bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(width: 10, height: 10))
                .cgPath
            itemButton.layer.mask = rectShape
        }
        
        return itemButton
    }
    
    private func makeCancelItem(item: SBUActionSheetItem) -> UIButton {
        let width:CGFloat = (self.window?.bounds.width ?? self.baseView.frame.width)
        let itemWidth: CGFloat = width - (self.sideMargin*2)
        let itemButton = UIButton(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: itemWidth, height: self.itemHeight)
            )
        )
        
        itemButton.setBackgroundImage(
            UIImage.from(color: theme.backgroundColor),
            for: .normal
        )
        itemButton.setBackgroundImage(
            UIImage.from(color: theme.highlightedColor),
            for: .highlighted
        )
        
        itemButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: itemWidth, height: itemHeight))
        titleLabel.text = item.title
        titleLabel.font = item.font ?? theme.actionSheetTextFont
        titleLabel.textColor = item.color ?? theme.actionSheetItemColor
        titleLabel.textAlignment = .center
        
        itemButton.addSubview(titleLabel)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = itemButton.frame
        rectShape.position = itemButton.center
        rectShape.path = UIBezierPath(
            roundedRect: itemButton.bounds,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
        itemButton.layer.mask = rectShape
        
        return itemButton
    }
    
    // MARK: Button action
    @objc private func onClickActionSheetButton(sender: UIButton) {
        self.dismiss()
        self.delegate?.didSelectActionSheetItem(
            index: sender.tag,
            identifier: self.identifier
        )
        
        let index = sender.tag
        let item = self.items[index]
        item.completionHandler?()
    }
    
    // MARK: Orientation
    @objc func orientationChanged(_ notification: NSNotification) {
        let currentOrientation = UIDevice.current.orientation
        
        if (prevOrientation.isPortrait && currentOrientation.isLandscape ||
            prevOrientation.isLandscape && currentOrientation.isPortrait) {
            dismiss()
        }

        self.prevOrientation = currentOrientation
    }
}

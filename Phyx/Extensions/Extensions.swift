//
//  Extensions.swift
//  Camp
//
//  Created by apple on 12/28/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import Foundation
import UIKit

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

}

extension Data {

    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }

}

extension Encodable {

    subscript(key: String) -> Any? {
        return dictionary[key]
    }

    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }

}

extension UIWindow {

    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {

        if vc.isKind(of: UINavigationController.self) {

            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)

        } else if vc.isKind(of: UITabBarController.self) {

            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)

        } else {

            if let presentedViewController = vc.presentedViewController {

                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)

            } else {

                return vc;
            }
        }
    }

}

// Date to timestamp conversions
extension Date {

    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }

}

extension UIView {

    func safeTopAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    func safeLeftAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        } else {
            return leftAnchor
        }
    }

    func safeBottomAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    func safeRightAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        } else {
            return rightAnchor
        }
    }

    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }

    static var primary: UIColor {
        return UIColor(netHex: 0xF6695F)
    }

    static var grayMessage: UIColor { return UIColor(netHex: 0xF6F6F6) }

    static var linkMessage: UIColor { return UIColor(netHex: 0x0000EE) }
    
    static var phyx: UIColor { return UIColor(netHex: 0x388DFB) }
    static var camp: UIColor { return UIColor(netHex: 0xF6695F) }
    static var gold: UIColor { return UIColor(netHex: 0xFFD700) }
    static var platinum: UIColor { return UIColor(netHex: 0xE5E4E2 ) }
    static var silver: UIColor { return UIColor(netHex: 0xC0C0C0) }
    static var bronze: UIColor { return UIColor(netHex: 0xCD7F32) }
    static var diamond: UIColor { return UIColor(netHex: 0x9AC5DB) }
}

extension CALayer {
    
    // USAGE: Custom add border function for layers
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    // USAGE: Used to get border from layer
    func getBorder(edge: UIRectEdge, thickness: CGFloat) -> CALayer? {
        var frame: CGRect!
        switch edge {
        case UIRectEdge.top:
            frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            frame = CGRect.init(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            frame = CGRect.init(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            frame = CGRect.init(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            frame = CGRect()
            break
        }
        
        for sublayer in self.sublayers! {
            if sublayer.frame == frame {
                return sublayer
            }
            
        }
        return nil
    }
}

extension Int64 {

    func toTimeInterval() -> TimeInterval! {
        return Double(self / 1000)
    }

}

extension UIFont {

    static func primary(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Book", size: size)!
    }

}

extension Array where Element: Comparable {

    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }

}

extension Float {
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
}


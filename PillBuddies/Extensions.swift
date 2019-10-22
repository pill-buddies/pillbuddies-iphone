//
//  Extensions.swift
//  PillBuddies
//
//  Created by William Harvey on 2019-09-12.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import Foundation
import UIKit
import SVGKit
import CoreData

// MARK: - UIColor

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// MARK: - SVGKImage

extension SVGKImage {
    convenience init(named: String) {
        if let imagePath = Bundle.main.path(forResource: named, ofType: "svg")
        {
            self.init(contentsOfFile: imagePath)
        }
        else {
            self.init()
        }
    }
}

// MARK: - UIView

extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var maskToBound: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

// MARK: - Date

extension Date {
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
    func addUnit(n: Int, u: Calendar.Component) -> Date {
        let cal = Calendar.current
        return cal.date(byAdding: u, value: n, to: self)!
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var today:  Date { return Date().morning }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    var morning: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: midnight)!
    }
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    static func getUnitByIndex(index: Int32) -> Calendar.Component {
        switch index {
        case 0: return .year
        case 1: return .month
        case 2: return .day
        case 3: return .hour
        case 4: return .minute
        case 5: return .second
        default: return .day
        }
    }
    static func getIndexByUnit(unit: Calendar.Component) -> Int32 {
        switch unit {
        case .year: return 0
        case .month: return 1
        case .day: return 2
        case .hour: return 3
        case .minute: return 4
        case .second: return 5
        default: return 2
        }
    }
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}

// MARK: - NSManagedObject

extension NSManagedObject {
    func copyProperties() -> NSManagedObject {
        let cloned = NSManagedObject(entity: self.entity, insertInto: nil)

        for (key,_) in self.entity.attributesByName {
            cloned.setValue(self.value(forKey: key), forKey: key)
        }

//        for (key,_) in self.entity.relationshipsByName {
//            let sourceSet = self.mutableSetValue(forKey: key)
//            let clonedSet = cloned.mutableSetValue(forKey: key)
//            let e = sourceSet.objectEnumerator()
//
//            var relatedObj = e.nextObject() as? NSManagedObject
//
//            while ((relatedObj) != nil) {
//
//                let clonedRelatedObject = relatedObj!.copyProperties()
//                clonedSet.add(clonedRelatedObject)
//                relatedObj = e.nextObject() as? NSManagedObject
//            }
//        }

        return cloned
    }
}

//MARK: - UIStackView
extension UIStackView {
    func removeAllArrangedSubviewsExceptFirst() {
        var skipFirst = true
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            if (skipFirst) {
                skipFirst = false
                return allSubviews
            }
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        removedSubviews.flatMap({ $0.constraints }).forEach { $0.isActive = false }
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

//MARK: - Schedules
extension Schedules {
    struct Holder {
        static var _logSet: NSSet?
    }
    public var logSet: NSSet? {
        get {
            return Holder._logSet
        }
        set(newValue) {
            Holder._logSet = newValue
        }
    }
}

//MARK: - Int
extension Int {
    func of<T>(iteration: (Int) -> T) -> [T] {
        var collection = [T]()
        for i in 0..<self {
            collection.append(iteration(i))
        }
        return collection
    }
}

//
//  Extensions.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/9/21.
//

import Foundation
import SwiftUI

extension String {
    var html2AttributedString: String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string

        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension Date {
    init?(timeString: String) {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        if let date = df.date(from: timeString) {
            self = date
        } else {
            return nil
        }
    }
}

extension UIColor {
    func hexString() -> String {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: nil)

        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

public extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        if cString.count == 8 {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = CGFloat((rgbValue & 0xFF00_0000) >> 24) / 255.0

        } else if cString.count == 6 {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = CGFloat(1.0)
        } else {
            self.init(Color(UIColor.lightGray))
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

public extension UIColor {
    var textColor: Color {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return ((r * 299) + (g * 587) + (b * 114)) / 1000 > 125 / 255 ? .black : .white
    }
}

public extension Color {
    var textColor: Color {
        return UIColor(self).textColor
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension String {
    var words: [String] {
        return split(separator: " ").map { String($0) }
    }
}

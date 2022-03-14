//
//  ThemeManager.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/13.
//  테마 관리

import UIKit
import Foundation

extension UIColor {
    /// 16진수 색상 코드로 색상가져오기
    func colorFromHexString (_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

enum Theme: Int {

    case white, black, rolling, lemon, undergrowth, lily, bubbly, meeting

    /// 배경 색상
    var backgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString("FFFFFF")
        case .black:
            return UIColor().colorFromHexString("000000")
        case .rolling:
            return UIColor().colorFromHexString("F4BBB8")
        case .lemon:
            return UIColor().colorFromHexString("F8D473")
        case .undergrowth:
            return UIColor().colorFromHexString("8FB789")
        case .lily:
            return UIColor().colorFromHexString("96D9E6")
        case .bubbly:
            return UIColor().colorFromHexString("9DABEC")
        case .meeting:
            return UIColor().colorFromHexString("D6CBF6")
        }
    }

    /// 보조 색상
    var secondaryColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString("F2F2F7")
        case .black:
            return UIColor().colorFromHexString("1C1C1E")
        case .rolling:
            return UIColor().colorFromHexString("FAE8E7")
        case .lemon:
            return UIColor().colorFromHexString("FEF6E2")
        case .undergrowth:
            return UIColor().colorFromHexString("D6F5D9")
        case .lily:
            return UIColor().colorFromHexString("D7F1F8")
        case .bubbly:
            return UIColor().colorFromHexString("DBE1F7")
        case .meeting:
            return UIColor().colorFromHexString("F4F2FD")
        }
    }

//    /// 주요 색상
//    var mainColor: UIColor {
//        switch self {
//        case .white:
//            return UIColor().colorFromHexString("FFFFFF")
//        case .black:
//            return UIColor().colorFromHexString("000000")
//        }
//    }
//
//    /// Customizing the Navigation Bar
//    var barStyle: UIBarStyle {
//        switch self {
//        case .black:
//            return .black
//        default:
//            return .default
//        }
//    }

//    var navigationBackgroundImage: UIImage? {
//        return self == .white ? UIImage(named: "navBackground") : nil
//    }
//
//    var tabBarBackgroundImage: UIImage? {
//        return self == .white ? UIImage(named: "tabBarBackground") : nil
//    }

//    var titleTextColor: UIColor {
//        switch self {
//        case .white:
//            return UIColor().colorFromHexString("ffffff")
//        case .black:
//            return UIColor().colorFromHexString("000000")
//        }
//    }
//    var subtitleTextColor: UIColor {
//        switch self {
//        case .white:
//            return UIColor().colorFromHexString("ffffff")
//        case .black:
//            return UIColor().colorFromHexString("000000")
//        }
//    }
}   // enum Theme

/// UserDefaults Key
let selectedThemeKey = "SelectedTheme"

/// This will let you use a theme in the app.
class ThemeManager {

    /// 현재 테마 가져오기
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            // nil일 때
            return .white
        }
    }

    /// 테마 적용하기
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}

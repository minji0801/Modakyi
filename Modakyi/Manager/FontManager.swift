//
//  FontManager.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/14.
//  폰트 관리

import UIKit
import Foundation

enum Font: Int {

    case elice, nanumR, nanumB, nanumSquareR, nanumSquareB, gowunBatang
    case gowunDodum, gangwonAll, kyobo2019, kyobo2020, uhbeeZziba, leeseoyun

    /// 아이폰 작은 글씨 (셀 글귀)
    var iPhoneSmallFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 10)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 10)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 10)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 10)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 10)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 10)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 10)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 10)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 10)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 10)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 10)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 10)!
        }
    }

    /// 아이폰 중간 글씨 (추천글귀)
    var iPhoneMediumFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 18)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 18)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 18)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 18)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 18)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 18)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 18)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 18)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 18)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 18)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 18)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 18)!
        }
    }

    /// 아이폰 큰 글씨 (상세화면 글귀)
    var iPhoneLargeFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 20)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 20)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 20)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 20)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 20)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 20)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 20)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 20)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 20)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 20)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 20)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 20)!
        }
    }

    /// 아이패드 작은 글씨 (셀 글귀)
    var iPadSmallFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 13)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 13)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 13)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 13)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 13)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 13)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 13)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 13)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 13)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 13)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 13)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 13)!
        }
    }

    /// 아이패드 중간 글씨 (추천글귀)
    var iPadMediumFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 21)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 21)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 21)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 21)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 21)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 21)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 21)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 21)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 21)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 21)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 21)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 21)!
        }
    }

    /// 아이패드 큰 글씨 (상세화면 글귀)
    var iPadLargeFont: UIFont {
        switch self {
        case .elice:
            return UIFont(name: "EliceDigitalBaeumOTF", size: 23)!
        case .nanumR:
            return UIFont(name: "NanumBarunpenOTF", size: 23)!
        case .nanumB:
            return UIFont(name: "NanumBarunpenOTF-Bold", size: 23)!
        case .nanumSquareR:
            return UIFont(name: "NanumSquareRoundOTFR", size: 23)!
        case .nanumSquareB:
            return UIFont(name: "NanumSquareRoundOTFB", size: 23)!
        case .gowunBatang:
            return UIFont(name: "GowunBatang-Regular", size: 23)!
        case .gowunDodum:
            return UIFont(name: "GowunDodum-Regular", size: 23)!
        case .gangwonAll:
            return UIFont(name: "GangwonEduAll-OTFBold", size: 23)!
        case .kyobo2019:
            return UIFont(name: "KyoboHandwriting2019", size: 23)!
        case .kyobo2020:
            return UIFont(name: "KyoboHandwriting2020", size: 23)!
        case .uhbeeZziba:
            return UIFont(name: "UhBeeZZIBA-Regular", size: 23)!
        case .leeseoyun:
            return UIFont(name: "LeeSeoyun", size: 23)!
        }
    }
}

let selectedFontKey = "SelectedFont"

class FontManager {

    /// 현재 폰트 가져오기
    static func currentFont() -> Font {
        if let storedFont = (UserDefaults.standard.value(forKey: selectedFontKey) as AnyObject).integerValue {
            return Font(rawValue: storedFont)!
        } else {
            // 저장된 폰트가 없을 때
            return .elice
        }
    }

    /// 폰트 저장하기
    static func applyFont(font: Font) {
        UserDefaults.standard.setValue(font.rawValue, forKey: selectedFontKey)
        UserDefaults.standard.synchronize()
    }
}

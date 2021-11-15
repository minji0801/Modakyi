//
//  TextOnLabel.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import Foundation

func TextOnLabel(_ eng: String, _ kor: String, _ who: String) -> String {
    if who.isEmpty {
        if eng.isEmpty {
            return kor
        } else if kor.isEmpty {
            return eng
        } else {
            return """
            \(eng)
            
            \(kor)
            """
        }
    } else {
        if eng.isEmpty {
            return """
            \(kor)
            
            \(who)
            """
        } else if kor.isEmpty {
            return """
            \(eng)
            
            \(who)
            """
        } else {
            return """
            \(eng)
            
            \(kor)
            
            \(who)
            """
        }
    }
}

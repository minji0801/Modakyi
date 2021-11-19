//
//  UIConfigure.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/16.
//

import Foundation
import UIKit

// UserDefaults에 저장된 값을 통해 다크모드 확인하는 메소드
func AppearanceCheck(_ viewController: UIViewController) {
    guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
    if appearance == "Dark" {
        viewController.overrideUserInterfaceStyle = .dark
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    } else {
        viewController.overrideUserInterfaceStyle = .light
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
}

// Firebase를 통해서 가져온 Text 데이터를 Label에 뿌려주는 메소드
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

// Indicator 천천히 없애는 메소드
func SlowlyRemoveIndicator(_ indicatorView: UIActivityIndicatorView, _ collectionView: UICollectionView) {
    UIView.animate(withDuration: 0.5) {
        indicatorView.stopAnimating()
        indicatorView.alpha = 0
        collectionView.alpha = 1
    }
}

// CollectionView Cell의 크기를 재조정하는 메소드
func ResizeCells(_ collectionView: UICollectionView?) {
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
        guard let flowLayout: UICollectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            layout.itemSize = CGSize.zero
            return
        }
        
        let width = ((collectionView?.bounds.width)! / 3) - 0.8
        let itemSize = CGSize(width: width, height: width)
        layout.itemSize = itemSize
        layout.invalidateLayout()
    }
}

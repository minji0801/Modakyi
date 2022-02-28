//
//  UIConfigure.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/16.
//  UI 관련 함수

import UIKit

/// UserDefaults에 저장된 값으로 다크모드 확인하기
func appearanceCheck(_ viewController: UIViewController) {
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

/// 데이터베이스에서 가져온 글귀를 Label에 뿌려주기
func textOnLabel(_ eng: String, _ kor: String, _ who: String) -> String {
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

/// Indicator 천천히 없애고 CollectionView 보여주기
func slowlyRemoveIndicator(_ indicatorView: UIActivityIndicatorView, _ collectionView: UICollectionView) {
    UIView.animate(withDuration: 0.5) {
        indicatorView.stopAnimating()
        indicatorView.alpha = 0
        collectionView.alpha = 1
    }
}

/// CollectionView Cell의 크기를 재조정하기
func resizeCells(_ collectionView: UICollectionView?) {
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
        guard (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout) != nil else {
            layout.itemSize = CGSize.zero
            return
        }

        let width = ((collectionView?.bounds.width)! / 3) - 0.8
        let itemSize = CGSize(width: width, height: width)
        layout.itemSize = itemSize
        layout.invalidateLayout()
    }
}

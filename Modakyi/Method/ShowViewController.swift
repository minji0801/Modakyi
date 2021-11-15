//
//  ShowViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/15.
//  ViewController 이동 메소드 모음

import Foundation
import UIKit

// MainViewController를 RootViewController로 보여주는 메소드
func showMainVCOnRoot() {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
    mainViewController.modalPresentationStyle = .fullScreen
    UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
}

// MainViewController를 NavigationController에 보여주는 메소드
func showMainVCOnNavigation(_ viewController: UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
    mainViewController.modalPresentationStyle = .fullScreen
    viewController.navigationController?.show(mainViewController, sender: nil)
}

// SettingViewController를 NavigationController에 push해서 보여주는 메소드
func pushSettingVCOnNavigation(_ viewController: UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
    viewController.navigationController?.pushViewController(settingViewController, animated: true)
}

// DetailViewController를 present해서 보여주는 메소드
func presentDetailViewController(_ viewController: UIViewController, _ recommendTextId: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
    detailViewController.id = recommendTextId
    viewController.present(detailViewController, animated: true, completion: nil)
}

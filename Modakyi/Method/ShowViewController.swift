//
//  ShowViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/15.
//  ViewController 이동 메소드 모음

import UIKit
import SafariServices

let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

// MainViewController를 RootViewController로 보여주는 메소드
func showMainVCOnRoot() {
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
    mainViewController.modalPresentationStyle = .fullScreen
    UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
}

// MainViewController를 NavigationController에 보여주는 메소드
func showMainVCOnNavigation(_ viewController: UIViewController) {
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
    mainViewController.modalPresentationStyle = .fullScreen
    viewController.navigationController?.show(mainViewController, sender: nil)
}

// SettingViewController를 NavigationController에 push해서 보여주는 메소드
func pushSettingVCOnNavigation(_ viewController: UIViewController) {
    guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
            as? SettingViewController else { return }
    viewController.navigationController?.pushViewController(settingViewController, animated: true)
}

// DetailViewController를 present해서 보여주는 메소드
func presentDetailViewController(_ viewController: UIViewController, _ textId: String) {
    guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController else { return }
    detailViewController.viewModel.id = textId
    viewController.present(detailViewController, animated: true, completion: nil)
}

// NoticeViewController를 present해서 보여주는 메소드
func presentNoticeViewController(_ viewController: UIViewController) {
    guard let noticeViewController = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
            as? NoticeViewController else { return }
    noticeViewController.modalPresentationStyle = .fullScreen
    viewController.present(noticeViewController, animated: false, completion: nil)
}

// TutorialViewController를 present해서 보여주는 메소드
func presentTutorialViewController(_ viewController: UIViewController) {
    let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
    tutorialViewController.modalPresentationStyle = .fullScreen
    viewController.present(tutorialViewController, animated: false, completion: nil)
}

// NetworkViewController를 RootViewController로 보여주는 메소드
func showNetworkVCOnRoot() {
    DispatchQueue.main.async {
        let networkViewController = storyboard.instantiateViewController(withIdentifier: "NetworkViewController")
        networkViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(networkViewController, sender: nil)
    }
}

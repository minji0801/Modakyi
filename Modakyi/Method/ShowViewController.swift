//
//  ShowViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/15.
//  화면 이동 함수

import UIKit

let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

/// MainViewController를 RootViewController로 보여주기
func showMainVCOnRoot() {
    guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            as? MainViewController else { return }
    mainViewController.modalPresentationStyle = .fullScreen
    UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
}

/// NetworkViewController를 RootViewController로 보여주기
func showNetworkVCOnRoot() {
    DispatchQueue.main.async {
        guard let networkViewController = storyboard.instantiateViewController(withIdentifier: "NetworkViewController")
                as? NetworkViewController else { return }
        networkViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(networkViewController, sender: nil)
    }
}

/// MainViewController를 NavigationController에 보여주기
func showMainVCOnNavigation(_ viewController: UIViewController) {
    guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            as? MainViewController else { return }
    mainViewController.modalPresentationStyle = .fullScreen
    viewController.navigationController?.show(mainViewController, sender: nil)
}

/// SettingViewController를 NavigationController에 push하기
func pushSettingVCOnNavigation(_ viewController: UIViewController) {
//    guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
//            as? SettingViewController else { return }
    guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingTableViewController")
            as? SettingTableViewController else { return }
    viewController.navigationController?.pushViewController(settingViewController, animated: true)
}

/// DetailViewController를 present하기
func presentDetailViewController(_ viewController: UIViewController, _ textId: String) {
    guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController else { return }
    detailViewController.viewModel.id = textId  // 글귀 아이디 넘겨주기
    viewController.present(detailViewController, animated: true, completion: nil)
}

/// NoticeViewController를 push하기
func pushToNoticeViewController(_ viewController: UIViewController) {
    guard let noticeViewController = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
            as? NoticeViewController else { return }
    viewController.navigationController?.pushViewController(noticeViewController, animated: true)
}

/// TutorialViewController를 present하기
func presentTutorialViewController(_ viewController: UIViewController) {
    guard let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
            as? TutorialViewController else { return }
    tutorialViewController.modalPresentationStyle = .fullScreen
    viewController.present(tutorialViewController, animated: false, completion: nil)
}

/// VersionViewController를 push하기
func pushToVersionViewController(_ viewController: UIViewController) {
    guard let versionViewController = storyboard.instantiateViewController(withIdentifier: "VersionViewController")
            as? VersionViewController else { return }
    viewController.navigationController?.pushViewController(versionViewController, animated: true)
}

/// AccountViewController를 push하기
func pushToAccountViewController(_ viewController: UIViewController) {
    guard let accountViewController = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
            as? AccountViewController else { return }
    viewController.navigationController?.pushViewController(accountViewController, animated: true)
}

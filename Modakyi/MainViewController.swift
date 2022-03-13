//
//  MainViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//  메인 ViewController (탭 바)

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /// 화면 보여질때 마다: 다크모드 확인, 네비게이션 바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }

    /// 탭 바 클릭되면 Noti 보내기(위로 스크롤해서 올라갈 수 있게)
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == item.tag {
            switch item.tag {
            case 0:
                NotificationCenter.default.post(
                    name: NSNotification.Name("HomeTabSelected"),
                    object: nil,
                    userInfo: nil
                )
            case 1:
                NotificationCenter.default.post(
                    name: NSNotification.Name("LikeTabSelected"),
                    object: nil,
                    userInfo: nil
                )
            case 2:
                NotificationCenter.default.post(
                    name: NSNotification.Name("UnusedTabSelected"),
                    object: nil,
                    userInfo: nil
                )
            case 3:
                NotificationCenter.default.post(
                    name: NSNotification.Name("SearchTabSelected"),
                    object: nil,
                    userInfo: nil
                )
            default:
                break
            }
        }
    }
}

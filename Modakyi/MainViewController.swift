//
//  MainViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = true
    }

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

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
        AppearanceCheck(self)
        navigationController?.navigationBar.isHidden = true
    }
}

//
//  DarkModeCheck.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/15.
//

import Foundation
import UIKit

func AppearanceCheck(_ viewController: UIViewController) {
    guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
    if appearance == "Dark" {
        viewController.overrideUserInterfaceStyle = .dark
    } else {
        viewController.overrideUserInterfaceStyle = .light
    }
}

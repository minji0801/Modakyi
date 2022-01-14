//
//  RoundButton.swift
//  Modakyi
//
//  Created by 김민지 on 2022/01/14.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.borderWidth = 1
                self.layer.cornerRadius = 10
                self.layer.borderColor = UIColor.darkGray.cgColor
                self.titleLabel?.font = UIFont(name: "HSSaemaul-Regular", size: 20)
            }
        }
    }
}

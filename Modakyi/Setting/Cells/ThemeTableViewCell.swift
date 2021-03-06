//
//  ThemeTableViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/13.
//  테마 변경 셀

import UIKit

class ThemeTableViewCell: UITableViewCell {
    let color = [
        "FFFFFF",
        "000000",
        "F4BBB8",
        "F8D473",
        "8FB789",
        "96D9E6",
        "9DABEC",
        "D6CBF6"
    ]

    let title = [
        "백설기",
        "검은콩",
        "꿀떡",
        "망고",
        "쑥떡",
        "구름",
        "가지",
        "블루베리스무디"
    ]

    func updateUI(_ row: Int) {
        self.textLabel?.text = title[row]
        self.imageView?.layer.cornerRadius = 5
        self.imageView?.layer.borderWidth = 0.5
        self.imageView?.layer.borderColor = UIColor.systemGray.cgColor
        self.imageView?.backgroundColor = UIColor().colorFromHexString(color[row])
    }
}

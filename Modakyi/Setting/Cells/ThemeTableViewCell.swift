//
//  ThemeTableViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/13.
//  테마 변경 셀

import UIKit

class ThemeTableViewCell: UITableViewCell {
    let color = [
        [255.0, 255.0, 255.0],
        [0.0, 0.0, 0.0],
        [244.0, 182.0, 76.0]
    ]

    let title = [
        "White",
        "Black",
        "Telepathy"
    ]

    func updateUI(_ row: Int) {
        self.textLabel?.text = title[row]
        self.imageView?.layer.cornerRadius = 5
        self.imageView?.layer.borderWidth = 0.5
        self.imageView?.layer.borderColor = UIColor.systemGray.cgColor
        self.imageView?.backgroundColor = UIColor(
            red: CGFloat(color[row][0] / 255.0),
            green: CGFloat(color[row][1] / 255.0),
            blue: CGFloat(color[row][2] / 255.0),
            alpha: CGFloat(1.0)
        )
    }
}

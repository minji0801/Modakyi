//
//  AppCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  클릭해서 해당 앱으로 이동하는 셀

import UIKit

class AppCell: UITableViewCell {
    let image = ["scoit", "hours"]
    let title = ["Scoit", "h:ours"]
    let subTitle = ["스쿼트 챌린지 앱", "시간 & 디데이 계산 앱"]

    func updateUI(_ row: Int) {
        self.imageView?.image = UIImage(named: image[row])
        self.textLabel?.text = title[row]
        self.detailTextLabel?.text = subTitle[row]
    }
}

//
//  AppCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//

import UIKit

class AppCell: UITableViewCell {
    var indexPath: IndexPath = [0, 0]
    let image = ["scoit", "hours"]
    let title = ["Scoit", "h:ours"]
    let subTitle = ["스쿼트 챌린지 앱", "시간 & 디데이 계산 앱"]

    func updateUI(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.imageView?.image = UIImage(named: image[indexPath.row])
        self.textLabel?.text = title[indexPath.row]
        self.detailTextLabel?.text = subTitle[indexPath.row]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

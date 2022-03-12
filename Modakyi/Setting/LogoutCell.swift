//
//  ClickCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  클릭해서 액션을 취하는 셀 > 로그아웃

import UIKit

class LogoutCell: UITableViewCell {
    func updateUI(_ indexPath: IndexPath) {
        self.textLabel?.text = "로그아웃"
    }
}

//
//  movingCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  클릭해서 이동하는 셀 > 알림설정, 테마, 글씨체, 공지사항, 문의 및 의견, 앱 평가, 이용 방법, 버전 정보

import UIKit

class MovingCell: UITableViewCell {
    let title = [["알림 설정", "테마 변경", "글씨체 변경"],
                 ["공지사항", "문의 및 의견", "앱 평가", "이용방법", "버전 정보"],
                 ["계정 정보"]]

    func updateUI(_ indexPath: IndexPath) {
        self.textLabel?.text = title[indexPath.section][indexPath.row]
    }
}

//
//  ThanksTableViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/15.
//  Thank 테이블 셀

import UIKit

final class ThanksTableViewCell: UITableViewCell {
    let title = [
        [   // Texts
            "@motemote_official",
            "@study.dapulja",
            "@livy.ooo",
            "@happy.life.korea",
            "@today_good_tip",
            "@very_good_tip",
            "@insight_trend",
            "@teongjang_kk"
        ],
        [   // Fonts
            "강원도교육청X헤움디자인",
            "교보문고",
            "네이버",
            "류양희",
            "어비",
            "앨리스",
            "토끼네활자공장",
            "흥국생명"
        ],
        [   // Icons
            "Microsoft",
            "Picons.me",
            "Tinti Nodarse"
        ],
        [   // Others
            "Minsun Hwang",
            "Habin Park",
            "Aengja Shin"
        ]
    ]

    func updateUI(_ indexPath: IndexPath) {
        self.textLabel?.text = title[indexPath.section][indexPath.row]
    }
}

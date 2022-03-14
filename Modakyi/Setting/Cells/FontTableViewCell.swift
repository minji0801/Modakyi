//
//  FontTableViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/14.
//  글씨체 변경 셀

import UIKit

class FontTableViewCell: UITableViewCell {
    let title = [
        "앨리스디지털배움체",
        "나눔바른펜R",
        "나눔바른펜B",
        "나눔스퀘어라운드R",
        "나눔스퀘어라운드B",
        "고운바탕",
        "고운돋움",
        "강원교육모두체",
        "교보손글씨",
        "교보손글씨 2020 박도연",
        "어비 찌바체",
        "이서윤체"
    ]

    let font = [
        "EliceDigitalBaeumOTF",
        "NanumBarunpenOTF",
        "NanumBarunpenOTF-Bold",
        "NanumSquareRoundOTFR",
        "NanumSquareRoundOTFB",
        "GowunBatang-Regular",
        "GowunDodum-Regular",
        "GangwonEduAll-OTFBold",
        "KyoboHandwriting2019",
        "KyoboHandwriting2020",
        "UhBeeZZIBA-Regular",
        "LeeSeoyun"
    ]

    func updateUI(_ row: Int) {
        self.textLabel?.text = title[row]
        self.textLabel?.font = UIFont(name: font[row], size: 15)
    }
}

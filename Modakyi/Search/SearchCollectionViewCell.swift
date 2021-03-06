//
//  SearchCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  검색 CollectionView Cell

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    @IBOutlet weak var textLabel: UILabel!

    /// 글귀 업데이트
    func updateTextLabel(_ text: StudyStimulateText, _ font: Font) {
        let eng = text.eng
        let kor = text.kor
        let who = text.who

        textLabel.text = textOnLabel(eng, kor, who)

        // 아이패트는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            textLabel.font = font.iPadSmallFont
        } else {
            textLabel.font = font.iPhoneSmallFont
        }
    }
}

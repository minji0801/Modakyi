//
//  HomeCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  홈 Collection View Cell

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var newImage: UIImageView!

    /// 글귀 라벨 업데이트
    func updateTextLabel(_ text: StudyStimulateText) {
        let eng = text.eng
        let kor = text.kor
        let who = text.who

        textLabel.text = textOnLabel(eng, kor, who)

        // 아이패드는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 13.0)
        }
    }

    /// 새로운 글귀 이미지(빨간점) 업데이트
    func updateNewImage(
        newTextIds newText: [String],
        clicekdTextIds clickedText: [String],
        textId index: Int
    ) {
        if newText.contains(String(index)) && !clickedText.contains(String(index)) {
            self.newImage.isHidden = false
        } else {
            self.newImage.isHidden = true
        }
    }
}

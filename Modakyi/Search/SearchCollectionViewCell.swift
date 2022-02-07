//
//  SearchCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!

    func updateUI(_ text: StudyStimulateText) {
        let eng = text.eng
        let kor = text.kor
        let who = text.who

        self.textLabel.text = textOnLabel(eng, kor, who)

        if UIDevice.current.model == "iPad" {
            self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 13.0)
        }
    }
}

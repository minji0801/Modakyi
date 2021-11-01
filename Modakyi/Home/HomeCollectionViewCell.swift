//
//  HomeCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    func labelUpdateUI(_ text: StudyStimulateText) {
        let eng = text.eng
        let kor = text.kor
        let who = text.who
        
        self.textLabel.text = TextOnLabel(eng, kor, who)
    }
}

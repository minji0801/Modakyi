//
//  HomeCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    
    func labelUpdateUI(_ text: StudyStimulateText) {
        let eng = text.eng
        let kor = text.kor
        let who = text.who
        
        self.textLabel.text = TextOnLabel(eng, kor, who)
        
        if UIDevice.current.model == "iPad" {
            self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 13.0)
        }
    }
    
    func imageUpdateUI(_ newTexts: [String], _ clickedTexts: [String], _ index: Int) {
        if newTexts.contains(String(index)) && !clickedTexts.contains(String(index))  {
            self.newImage.isHidden = false
        } else {
            self.newImage.isHidden = true
        }
    }
}

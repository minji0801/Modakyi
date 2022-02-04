//
//  LikeCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseDatabase

class LikeCollectionViewCell: UICollectionViewCell {
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var textLabel: UILabel!
    
    func labelUpdateUI(_ likeTexts: [Int], _ indexPath: IndexPath) {
        let id = likeTexts[indexPath.row]
        ref.child("Text/Text\(id)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }
            
            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!
            
            self.textLabel.text = TextOnLabel(eng, kor, who)
            
            if UIDevice.current.model == "iPad" {
                self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 13.0)
            }
        }
    }
}

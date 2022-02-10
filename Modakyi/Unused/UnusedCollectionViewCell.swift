//
//  UnusedCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseDatabase

class UnusedCollectionViewCell: UICollectionViewCell {
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var textLabel: UILabel!

    func labelUpdateUI(_ unusedTexts: [Int], _ indexPath: IndexPath) {
        let id = unusedTexts[indexPath.row]
        ref.child("Text/Text\(id)").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.textLabel.text = textOnLabel(eng, kor, who)

            if UIDevice.current.model == "iPad" {
                self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 13.0)
            }
        }
    }
}

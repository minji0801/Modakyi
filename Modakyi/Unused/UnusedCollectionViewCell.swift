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
        ref.child("Text/Text\(id)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.textLabel.text = TextOnLabel(eng, kor, who)
        }
    }
}
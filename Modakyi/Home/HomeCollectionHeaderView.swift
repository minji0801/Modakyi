//
//  HomeCollectionHeaderView.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseDatabase

class HomeCollectionHeaderView: UICollectionReusableView {
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!

    func updateText(_ recommendTextId: String) {
        self.ref.child("Text/Text\(recommendTextId)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.recommendLabel.text = textOnLabel(eng, kor, who)

            if UIDevice.current.model == "iPad" {
                self.recommendLabel.font = UIFont(name: "EliceDigitalBaeum", size: 21.0)
            }
        }
    }
}

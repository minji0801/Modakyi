//
//  HomeCollectionHeaderView.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  홈 Collection View Header

import UIKit
import FirebaseDatabase

final class HomeCollectionHeaderView: UICollectionReusableView {
    static let identifier = "HomeCollectionHeaderView"
    private let ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!

    /// 글귀 업데이트
    func updateTextLabel(_ recommendTextId: String, _ font: Font) {
        ref.child("Text/Text\(recommendTextId)").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.recommendLabel.text = textOnLabel(eng, kor, who)

            // 아이패드는 글자 크기 크게
            if UIDevice.current.model == "iPad" {
                self.recommendLabel.font = font.iPadMediumFont
            } else {
                self.recommendLabel.font = font.iPhoneMediumFont
            }
        }
    }
}

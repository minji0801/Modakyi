//
//  LikeCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  좋아하는 글귀 CollectionView Cell

import UIKit
import FirebaseDatabase

final class LikeCollectionViewCell: UICollectionViewCell {
    static let identifier = "LikeCollectionViewCell"
    private let ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var textLabel: UILabel!

    /// 글귀 라벨 업데이트
    func updateTextLabel(_ likeTexts: [Int], _ indexPath: IndexPath, _ font: Font) {
        let id = likeTexts[indexPath.row]

        ref.child("Text/Text\(id)").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.textLabel.text = textOnLabel(eng, kor, who)

            // 아이패드는 글자 크기 크게
            if UIDevice.current.model == "iPad" {
                self.textLabel.font = font.iPadSmallFont
            } else {
                self.textLabel.font = font.iPhoneSmallFont
            }
        }
    }
}

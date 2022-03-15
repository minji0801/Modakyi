//
//  UnusedCollectionViewCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  미사용 글귀 CollectionView Cell

import UIKit
import FirebaseDatabase

final class UnusedCollectionViewCell: UICollectionViewCell {
    static let identifier = "UnusedCollectionViewCell"
    private let ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var textLabel: UILabel!

    /// 글귀 업데이트
    func updateTextLabel(_ unusedTexts: [Int], _ indexPath: IndexPath, _ font: Font) {
        let id = unusedTexts[indexPath.row]
        ref.child("Text/Text\(id)").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!

            self.textLabel.text = textOnLabel(eng, kor, who)

            /// 아이패드는 글자 크기 크게
            if UIDevice.current.model == "iPad" {
                self.textLabel.font = font.iPadSmallFont
            } else {
                self.textLabel.font = font.iPhoneSmallFont
            }
        }
    }
}

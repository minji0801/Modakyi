//
//  DetailViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/26.
//  글귀 상세 ViewModel

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class DetailViewModel {
    private let ref: DatabaseReference! = Database.database().reference()
    private let uid = Auth.auth().currentUser?.uid

    lazy var likeTextIDs = [Int]()  // 좋아하는 글귀 아이디
    lazy var usedTextIDs = [Int]()  // 사용한 글귀 아이디
    lazy var id = ""                // 글귀 아이디

    // 글귀 가져오기
    func getText(completion: @escaping (String, String, String) -> Void) {

        ref.child("Text/Text\(id)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }

            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!
            completion(eng, kor, who)
        }
    }

    /// 좋아하는 글귀 아이디 가져오기
    func getLikeTextIDs(completion: @escaping () -> Void) {
        ref.child("User/\(uid!)/like").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }

            if let value = snapshot.value as? [Int] {
                self.likeTextIDs = value
            }
            completion()
        }
    }

    /// 사용한 글귀 아이디 가져오기
    func getUsedTextIDs(completion: @escaping () -> Void) {
        ref.child("User/\(uid!)/used").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }

            if let value = snapshot.value as? [Int] {
                self.usedTextIDs = value
            }
            completion()
        }
    }

    /// 좋아하는 글귀 아이디 업데이트
    func updateLikeTextIDs(_ isSelected: Bool, _ sender: UIButton) {
        if isSelected { // 좋아하는 글귀 데이터 빼기
            likeTextIDs.remove(at: likeTextIDs.firstIndex(of: sender.tag)!)
        } else {    // 좋아하는 글귀 데이터 넣기
            likeTextIDs.append(sender.tag)
        }
        ref.child("User/\(uid!)").updateChildValues(["like": likeTextIDs])
    }

    /// 사용한 글귀 아이디 업데이트
    func updateUsedTextIDs(_ isSelected: Bool, _ sender: UIButton) {
        if isSelected { // 사용한 글귀 데이터 빼기
            usedTextIDs.remove(at: usedTextIDs.firstIndex(of: sender.tag)!)
        } else {    // 사용한 글귀 데이터 넣기
            usedTextIDs.append(sender.tag)
        }
        ref.child("User/\(uid!)").updateChildValues(["used": usedTextIDs.sorted()])
    }
}

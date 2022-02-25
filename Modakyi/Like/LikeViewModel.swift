//
//  LikeViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/25.
//  좋아하는 글귀 ViewModel

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class LikeViewModel {
    private let ref: DatabaseReference! = Database.database().reference()
    private let uid = Auth.auth().currentUser?.uid

    lazy var likeTextIDs: [Int] = [] // 좋아하는 글귀 id

    /// 좋아하는 글귀 개수
    var numOfLikeText: Int {
        return likeTextIDs.count
    }

    /// 좋아하는 글귀 아이디 조회
    func likeTextId(at index: Int) -> String {
        return String(likeTextIDs[index])
    }

    /// 좋아하는 글귀 아이디 가져오기
    func getLikeTextIDs(completion: @escaping (Bool) -> Void) {
        ref.child("User/\(uid!)/like").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value as? [Int] else {
                // 좋아하는 글귀가 없음
                self.likeTextIDs = []
                completion(false)
                return
            }

            self.likeTextIDs = value.reversed()
            completion(true)
        }
    }
}

//
//  UnusedViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/26.
//  미사용 글귀 ViewModel

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class UnusedViewModel {
    private let ref: DatabaseReference! = Database.database().reference()
    private let uid = Auth.auth().currentUser?.uid

    lazy var fullText: [StudyStimulateText] = [] // 전체 글귀
    lazy var unusedTextIDs = [Int]()  // 미사용 글귀 아이디

    /// 미사용 글귀 개수
    var numOfUnusedText: Int {
        return unusedTextIDs.count
    }

    /// 미사용 글귀 아이디 조회
    func unusedTextId(at index: Int) -> String {
        return String(unusedTextIDs[index])
    }

    /// 전체 글귀 가져오기
    func getFullText() {
        ref.child("Text").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: String]] else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)

                self.fullText = texts.sorted { Int($0.id)! > Int($1.id)! }
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }

    /// 사용자가 사용한 글귀 아이디 가져오기
    func getUnusedTextIDs(completion: @escaping (Bool) -> Void) {
        ref.child("User/\(uid!)/used").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value as? [Int] else {
                // 사용한 글귀가 없음 -> 미사용 글귀 아이디 = 전체 글귀 아이디
                self.unusedTextIDs = self.fullText.map { Int($0.id)! }
                completion(false)
                return
            }

            self.unusedTextIDs = self.fullText.indices.filter { !(value.contains($0)) }.sorted(by: >)
            completion(true)
        }
    }
}

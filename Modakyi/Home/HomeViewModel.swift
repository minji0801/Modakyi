//
//  HomeViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/25.
//  홈 ViewModel: ViewController와 Model 연결 담당 (실제 로직)

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class HomeViewModel {
    private let ref: DatabaseReference! = Database.database().reference()
    private let uid: String? = Auth.auth().currentUser?.uid

    lazy var allText: [StudyStimulateText] = [] // 전체 글귀
    lazy var recommendedTextId = ""             // 추천 글귀 id
    lazy var newTextIDs: [String] = []          // 새 글귀 id
    lazy var clickedTextIDs: [String] = []      // 클릭한 글귀 id

    /// 전체 글귀 개수
    var numOfFullText: Int {
        return allText.count
    }

    /// 글귀 정보 조회
    func textInfo(at index: Int) -> StudyStimulateText {
        return allText[index]
    }

    /// 전체 글귀, 추천 글귀 아이디, 새로운 글귀 아이디 가져오기
    func getFullText(completion: @escaping () -> Void) {
        ref.child("Text").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: String]] else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)

                self.allText = texts.sorted { Int($0.id)! > Int($1.id)! }
                self.recommendedTextId = self.allText.randomElement()!.id
                self.newTextIDs = self.allText.filter { self.timeDifference(uploadTime: $0.time) }.map { $0.id }
                completion()

            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }

    /// 시간 차이 구하기
    func timeDifference(uploadTime time: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")

        let current = formatter.string(from: Date())

        guard let startTime = formatter.date(from: time) else { return false }
        guard let endTime = formatter.date(from: current) else { return false }

        return Int(endTime.timeIntervalSince(startTime)) < 86400 ? true : false
    }

    /// 사용자가 클릭한 글귀 아이디 가져오기
    func getClickedTextId() {
        ref.child("User/\(uid!)/clicked").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }

            if let value = snapshot.value as? [String] {
                self.clickedTextIDs = value
            }
        }
    }

    /// 클릭한 글귀 업데이트
    func updateClickedText(at index: Int) {
        // 글귀 클릭한 적 없으면 클릭한 글귀에 추가하기: 빨간 점 있을 때 없애기 위해서
        if !clickedTextIDs.contains(textInfo(at: index).id) {
            clickedTextIDs.append(textInfo(at: index).id)
            self.ref.child("User/\(self.uid!)").updateChildValues(["clicked": clickedTextIDs])
        }
    }
}

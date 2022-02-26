//
//  SearchViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/26.
//  검색 ViewModel

import Foundation
import FirebaseDatabase

final class SearchViewModel {
    private let ref: DatabaseReference! = Database.database().reference()

    lazy var fullText: [StudyStimulateText] = [] // 전체 글귀

    /// 전체 글귀 개수
    var numOfFullText: Int {
        return fullText.count
    }

    /// 글귀 정보 조회
    func textInfo(at index: Int) -> StudyStimulateText {
        return fullText[index]
    }

    /// 전체 글귀 가져오기
    func getFullText(completion: @escaping () -> Void) {
        ref.child("Text").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: String]] else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)

                self.fullText = texts.sorted { Int($0.id)! > Int($1.id)! }
                completion()
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }

    /// 검색
    func search(_ searchWord: String, completion: @escaping () -> Void) {
        ref.child("Text").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: String]] else { return }

            let searchResult = value.filter {
                $0.value.contains {
                    $0.value.contains(searchWord)
                }
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: searchResult)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)

                self.fullText = texts.sorted { Int($0.id)! > Int($1.id)! }
                print("ViewModel 검색결과: \(self.fullText)")
                completion()
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }
}

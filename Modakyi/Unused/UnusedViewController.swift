//
//  UnusedViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UnusedViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    var studyStimulateTexts: [StudyStimulateText] = []
    var unusedTexts = [Int]()
    
    let uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text DB에서 글귀 데이터 읽어오기
        ref.child("Text").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: String]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)
                self.studyStimulateTexts = texts.sorted { Int($0.id)! > Int($1.id)! }
//                print("Unused - studyStimulateText: \(self.studyStimulateTexts)")
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
        
        // User DB에서 현재 사용자가 사용한 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/used").observe(.value) { snapshot in
            guard let value = snapshot.value as? [Int] else {
                // 사용한 글귀가 없으니까 전체 글귀 보여주기
                self.unusedTexts = self.studyStimulateTexts.map { Int($0.id)! }
//                print("Unused 미사용 글귀 id: \(self.unusedTexts)")
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    
                    // 로딩뷰 천천히 없애기
//                    UIView.animate(withDuration: 0.5) {
//                        self.loadingView.alpha = 0
//                    }
                }
                return
            }
            
            self.unusedTexts = self.studyStimulateTexts.indices.filter { !(value.contains($0)) }.sorted(by: >)
            print("Unused 미사용 글귀 id: \(self.unusedTexts)")
            
            DispatchQueue.main.async {
                if self.unusedTexts.isEmpty {
                    self.labelView.isHidden = false
                } else {
                    self.labelView.isHidden = true
                }
                self.collectionview.reloadData()
                
                // 로딩뷰 천천히 없애기
//                UIView.animate(withDuration: 0.5) {
//                    self.loadingView.alpha = 0
//                }
            }
        }
    }
}

// MARK: - UICollectionView Configure

extension UnusedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.unusedTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnusedCollectionViewCell", for: indexPath) as? UnusedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // usedTest 넘겨서 각 셀에서 id 검색해서 포함하지 않으면 textLabel에 글귀 뿌려주기
        cell.labelUpdateUI(unusedTexts.sorted(by: >), indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UnusedCollectionHeaderView", for: indexPath) as? UnusedCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
}

extension UnusedViewController: UICollectionViewDelegate {
    // 셀 클릭했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.id = String(unusedTexts[indexPath.row])
        self.present(detailViewController, animated: true, completion: nil)
    }
}

extension UnusedViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기 정하기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

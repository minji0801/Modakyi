//
//  LikeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LikeViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    var likeTexts = [Int]()
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User DB에서 현재 사용자가 좋아하는 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/like").observe(.value) { snapshot in
            guard let value = snapshot.value as? [Int] else {
                // 좋아하는 글귀가 없으니까
                self.likeTexts = []
                DispatchQueue.main.async {
                    self.labelView.isHidden = false
                    self.collectionview.reloadData()
                    
                    // 로딩뷰 천천히 없애기
//                    UIView.animate(withDuration: 0.5) {
//                        self.loadingView.alpha = 0
//                    }
                }
                return
            }
            
            self.likeTexts = value.sorted(by: >)
            print("Like 좋아하는 글귀 id: \(self.likeTexts)")
            
            DispatchQueue.main.async {
                self.labelView.isHidden = true
                self.collectionview.reloadData()
                
                // 로딩뷰 천천히 없애기
//                UIView.animate(withDuration: 0.5) {
//                    self.loadingView.alpha = 0
//                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
        if appearance == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
}

// MARK: - UICollectionView Configure

extension LikeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.likeTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as? LikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // likeTest 넘겨서 각 셀에서 id 검색해서 textLabel에 글귀 뿌려주기
        cell.labelUpdateUI(likeTexts, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LikeCollectionHeaderView", for: indexPath) as? LikeCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
}

extension LikeViewController: UICollectionViewDelegate {
    // 셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.id = String(likeTexts[indexPath.row])
        self.present(detailViewController, animated: true, completion: nil)
    }
}

extension LikeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기 정하기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

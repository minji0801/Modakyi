//
//  HomeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    var studyStimulateTexts: [StudyStimulateText] = []
    var recommendTextId = ""
    
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadingView.alpha = 1
        
        // Text DB에서 글귀 데이터 읽어오기
        ref.child("Text").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: String]] else { return }
//            print("value: \(value)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)
                self.studyStimulateTexts = texts.sorted { Int($0.id)! > Int($1.id)! }
//                print("Home - studyStimulateText: \(self.studyStimulateTexts)")
                
                // 추천 글귀 가져와 라벨에 뿌려주기
                self.recommendTextId = self.studyStimulateTexts.randomElement()!.id
                self.ref.child("Text/Text\(self.recommendTextId)").observe(.value) { snapshot in
                    guard let value = snapshot.value as? [String: String] else { return }

                    let eng = value["eng"]!
                    let kor = value["kor"]!
                    let who = value["who"]!

                    self.recommendLabel.text = TextOnLabel(eng, kor, who)
                }
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    
                    // 로딩뷰 천천히 없애기
//                    UIView.animate(withDuration: 0.5) {
//                        self.loadingView.alpha = 0
//                    }
                }
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recommendView.layer.cornerRadius = 30
        
        guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
        if appearance == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @IBAction func recommendViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.id = recommendTextId
        self.present(detailViewController, animated: true, completion: nil)
    }
}


// MARK: - UICollectionView Configure

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studyStimulateTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let text = self.studyStimulateTexts[indexPath.row]
        cell.labelUpdateUI(text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // 셀 클릭했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.id = studyStimulateTexts[indexPath.row].id
        self.present(detailViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

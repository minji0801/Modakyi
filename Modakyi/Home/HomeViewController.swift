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
    let uid = Auth.auth().currentUser?.uid
    
    var studyStimulateTexts: [StudyStimulateText] = []
    var newTextIDs: [String] = []
    var clickedTextIDs = [String]()
    
    var recommendTextId = ""
    var currentTime = ""
    
    private var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionview.alpha = 0
        self.collectionview.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissDetailNotification(_:)), name: NSNotification.Name("DismissDetailView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectedHomeTabNotification(_:)), name: NSNotification.Name("HomeTabSelected"), object: nil)
        
        // Text DB에서 글귀 데이터 읽어오기
        ref.child("Text").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: String]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)
                self.studyStimulateTexts = texts.sorted { Int($0.id)! > Int($1.id)! }
                
                self.recommendTextId = self.studyStimulateTexts.randomElement()!.id
                
                // New 글귀 찾기
                self.getCurrentTime()
                self.newTextIDs = self.studyStimulateTexts.filter { self.timeDifference($0.time) }.map { $0.id }
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    SlowlyRemoveIndicator(self.indicatorView, self.collectionview)
                }
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
        
        // User DB에서 현재 사용자가 클릭한 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/clicked").observe(.value) { snapshot in
            if let value = snapshot.value as? [String] {
                self.clickedTextIDs = value
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }
    
    // 화면 회전될 때
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ResizeCells(self.collectionview)
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionview.reloadData()
        }
    }
    
    @objc func selectedHomeTabNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }
    
    @objc func settingButtonTapped(_ sender: UIButton) {
        pushSettingVCOnNavigation(self)
    }
    
    @objc func refresh() {
        // 추천 글귀 다시 가져오기
        self.recommendTextId = self.studyStimulateTexts.randomElement()!.id
        DispatchQueue.main.async {
            self.collectionview.reloadData()
        }
    }
    
    // 추천 글귀 클릭 시
    @IBAction func recommendViewTapped(_ sender: UITapGestureRecognizer) {
        presentDetailViewController(self, self.recommendTextId)
    }
    
    // 현재 시간 구하기
    func getCurrentTime() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        self.currentTime = dateFormatter.string(from: now)
    }
    
    // 시간 차이 구하기
    func timeDifference(_ start: String) -> Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let startTime = format.date(from: start) else { return false }
        guard let endTime = format.date(from: self.currentTime) else { return false }
        
        let useTime = Int(endTime.timeIntervalSince(startTime))
        if useTime < 86400 {
            return true
        } else {
            return false
        }
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
        cell.imageUpdateUI(self.newTextIDs, self.clickedTextIDs, studyStimulateTexts.count - indexPath.row - 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        header.recommendView.layer.cornerRadius = 30
        header.updateText(self.recommendTextId)
        header.settingButton.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !clickedTextIDs.contains(studyStimulateTexts[indexPath.row].id) {
            self.clickedTextIDs.append(studyStimulateTexts[indexPath.row].id)
            self.ref.child("User/\(self.uid!)").updateChildValues(["clicked": self.clickedTextIDs])
        }
        
        presentDetailViewController(self, studyStimulateTexts[indexPath.row].id)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

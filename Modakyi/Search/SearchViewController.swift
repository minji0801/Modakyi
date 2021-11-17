//
//  SearchViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    var studyStimulateTexts: [StudyStimulateText] = []
    var searchTexts: [StudyStimulateText] = []
    var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readAllText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectedSearchTabNotification(_:)), name: NSNotification.Name("SearchTabSelected"), object: nil)
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
    
    @objc func selectedSearchTabNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }
    
    // 전제 글귀 읽어오기
    func readAllText() {
        ref.child("Text").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: String]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)
                self.studyStimulateTexts = texts.sorted { Int($0.id)! > Int($1.id)! }
                //                print("Search - studyStimulateText: \(self.studyStimulateTexts)")
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionView Configure

extension SearchViewController: UICollectionViewDataSource {
    // 셀 몇개 표현할래?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studyStimulateTexts.count
    }
    
    // 셀 어떻게 표현할래?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let text = self.studyStimulateTexts[indexPath.row]
        cell.updateUI(text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionHeaderView", for: indexPath) as? SearchCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        header.searchBar.delegate = self
        self.searchBar = header.searchBar
        return header
    }
}

extension SearchViewController: UICollectionViewDelegate {
    // 셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewController(self, studyStimulateTexts[indexPath.row].id)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기 정하기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

// MARK: - UISearch Bar Configure

extension SearchViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        // 키보드 내리기
        searchBar.resignFirstResponder()
    }
    
    // 취소버튼 눌렀을 때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !self.labelView.isHidden {
            self.labelView.isHidden = true
        }
        
        dismissKeyboard()
        searchBar.showsCancelButton = false
        
        // 다시 전체 글귀 보여주기
        readAllText()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 검색창 눌렀을 때
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색버튼 눌렀을 때
        dismissKeyboard()
        
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        print("검색어: \(searchTerm)")
        
        ref.child("Text").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: String]] else { return }
            
            let searchResult = value.filter {
                $0.value.contains {
                    $0.value.contains(searchTerm)
                }
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: searchResult)
                let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
                let texts = Array(textData.values)
                self.studyStimulateTexts = texts.sorted { Int($0.id)! > Int($1.id)! }
                print("검색결과: \(self.studyStimulateTexts)")
                
                DispatchQueue.main.async {
                    if self.studyStimulateTexts.isEmpty {
                        self.labelView.isHidden = false
                    } else {
                        self.labelView.isHidden = true
                    }
                    self.collectionview.reloadData()
                }
            } catch let error {
                print("ERROR JSON Parsing \(error.localizedDescription)")
            }
        }
    }
}

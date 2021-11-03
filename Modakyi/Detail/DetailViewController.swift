//
//  DetailViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var id = ""
    
    var likeTexts = [Int]()
    var usedTexts = [Int]()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Detail id: \(id)")
        
        // id로 글귀 데이터 가져오기
        ref.child("Text/Text\(id)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }
            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!
            self.textLabel.text = TextOnLabel(eng, kor, who)
        }
        
        // User DB에서 현재 사용자가 좋아하는 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/like").observe(.value) { snapshot in
            if let value = snapshot.value as? [Int] {
                self.likeTexts = value
            }
            print("Detail 좋아하는 글귀 id: \(self.likeTexts)")
            self.viewWillAppear(true)
        }
        
        // User DB에서 현재 사용자가 사용한 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/used").observe(.value) { snapshot in
            guard let value = snapshot.value as? [Int] else { return }
            print("Detail 사용 글귀 id: \(value)")
            self.usedTexts = value
            self.viewWillAppear(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likeButton.tag = Int(id)!
        checkButton.tag = Int(id)!

        if likeTexts.contains(Int(id)!) {
            // isSelected로 바꾸고, 색상 핑크로
            likeButton.isSelected = true
            likeButton.tintColor = .systemPink
        } else {
            // isSelected 풀고, 색상 블랙으로
            likeButton.isSelected = false
            likeButton.tintColor = .label
        }

        if usedTexts.contains(Int(id)!) {
            // isSelected로 바꾸기
            checkButton.isSelected = true
        } else {
            // isSelected 풀기
            checkButton.isSelected = false
        }
        
        guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
        if appearance == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        print("\(sender.tag) like button clicked!")
        
        if sender.isSelected {
            // 데이터 빼고 리로드
            likeTexts.remove(at: likeTexts.firstIndex(of: sender.tag)!)
            ref.child("User/\(uid!)").updateChildValues(["like": likeTexts])
            self.viewDidAppear(true)

        } else {
            // 데이터 넣고 리로드
            likeTexts.append(sender.tag)
            ref.child("User/\(uid!)").updateChildValues(["like": likeTexts])
            self.viewDidAppear(true)
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        print("\(sender.tag) check button clicked!")
        
        if sender.isSelected {
            // 데이터 빼고 리로드
            usedTexts.remove(at: usedTexts.firstIndex(of: sender.tag)!)
            ref.child("User/\(uid!)").updateChildValues(["used": usedTexts.sorted()])
            self.viewDidAppear(true)

        } else {
            // 데이터 넣고 리로드
            usedTexts.append(sender.tag)
            ref.child("User/\(uid!)").updateChildValues(["used": usedTexts.sorted()])
            self.viewDidAppear(true)
        }
    }
}

//
//  DetailViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMobileAds

class DetailViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    var likeTextIDs = [Int]()
    var usedTextIDs = [Int]()
    var id = ""
    
    @IBOutlet weak var textIdLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/4042418339"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        textIdLabel.text = "글귀 \(id)"
        
        // id로 글귀 데이터 가져오기
        ref.child("Text/Text\(id)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: String] else { return }
            let eng = value["eng"]!
            let kor = value["kor"]!
            let who = value["who"]!
            
            self.textLabel.text = TextOnLabel(eng, kor, who)
            
            if UIDevice.current.model == "iPad" {
                self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 23.0)
            }
        }
        
        // User DB에서 현재 사용자가 좋아하는 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/like").observe(.value) { snapshot in
            if let value = snapshot.value as? [Int] {
                self.likeTextIDs = value
            }
            self.viewWillAppear(true)
        }
        
        // User DB에서 현재 사용자가 사용한 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/used").observe(.value) { snapshot in
            if let value = snapshot.value as? [Int] {
                self.usedTextIDs = value
            }
            self.viewWillAppear(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        
        likeButton.tag = Int(id)!
        checkButton.tag = Int(id)!
        
        if likeTextIDs.contains(Int(id)!) {
            likeButton.isSelected = true
            likeButton.tintColor = .systemPink
        } else {
            likeButton.isSelected = false
            likeButton.tintColor = .label
        }
        
        if usedTextIDs.contains(Int(id)!) {
            checkButton.isSelected = true
            checkButton.tintColor = .systemGreen
        } else {
            checkButton.isSelected = false
            checkButton.tintColor = .label
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissDetailView"), object: nil, userInfo: nil)
    }
    
    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // 좋아요 버튼 클릭
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            // 데이터 빼고 리로드
            likeTextIDs.remove(at: likeTextIDs.firstIndex(of: sender.tag)!)
            ref.child("User/\(uid!)").updateChildValues(["like": likeTextIDs])
            self.viewDidAppear(true)
            
        } else {
            // 데이터 넣고 리로드
            likeTextIDs.append(sender.tag)
            ref.child("User/\(uid!)").updateChildValues(["like": likeTextIDs])
            self.viewDidAppear(true)
        }
    }
    
    // 공유하기 버튼 클릭
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "공유하기", message: "해당 글귀의 텍스트나 이미지를 공유해보세요.", preferredStyle: .actionSheet)
        let textShareAction = UIAlertAction(title: "텍스트 공유하기", style: .default) { _ in
            var objectsToShare = [String]()
            if let text = self.textLabel.text {
                objectsToShare.append(text)
            }
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        
        let imageShareAction = UIAlertAction(title: "이미지 공유하기", style: .default) { _ in
            guard let image = self.textView.transfromToImage() else { return }
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(textShareAction)
        alert.addAction(imageShareAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 체크 버튼 클릭
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            // 데이터 빼고 리로드
            usedTextIDs.remove(at: usedTextIDs.firstIndex(of: sender.tag)!)
            ref.child("User/\(uid!)").updateChildValues(["used": usedTextIDs.sorted()])
            self.viewDidAppear(true)
            
        } else {
            // 데이터 넣고 리로드
            usedTextIDs.append(sender.tag)
            ref.child("User/\(uid!)").updateChildValues(["used": usedTextIDs.sorted()])
            self.viewDidAppear(true)
        }
    }
}

// UIView를 Image로 변환하기
extension UIView {
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}

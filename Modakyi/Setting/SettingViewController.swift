//
//  SettingViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/02.
//

import UIKit
import FirebaseAuth
import Kingfisher
import SafariServices

class SettingViewController: UIViewController {
    let uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var notificationSettingButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var usewayButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        [notificationSettingButton, darkModeButton, noticeButton, commentsButton, usewayButton, logoutButton].forEach {
            $0?.layer.borderWidth = 0.3
            $0?.layer.cornerRadius = 10
            $0?.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        // Profile Image / UserName
        let username = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "User"
        let profileImg = Auth.auth().currentUser?.photoURL ?? URL(string: "")

        nameLabel.text = username
        profileImage.kf.setImage(with: profileImg, placeholder: UIImage(systemName: "person.crop.circle"))
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func darkmodeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        } else {
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
//        self.tableview.reloadData()
        self.viewWillAppear(true)
    }
    
    // 알림설정 버튼 클릭 시
    @IBAction func notificationSettingButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // 다크모드 버튼 클릭 시
    @IBAction func darckModeButtonTapped(_ sender: UIButton) {
        if self.overrideUserInterfaceStyle == .light {
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        } else {
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
        self.viewWillAppear(true)
    }
    
    // 공지사항 버튼 클릭 시
    @IBAction func noticeButtonTapped(_ sender: UIButton) {
        // 공지사항 화면 보여주기
    }
    
    // 문의 및 의견 버튼 클릭 시
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        // 이메일 보내는 화면으로 이동하기
    }
    
    // 이용방법 버튼 클릭 시
    @IBAction func usewayButtonTapped(_ sender: UIButton) {
        let url = NSURL(string: "https://midi-dill-147.notion.site/3a762cd2888e40f08e392f31667020ff")
        let safariView: SFSafariViewController = SFSafariViewController(url: url! as URL)
        self.present(safariView, animated: true, completion: nil)
    }
    
    // 로그아웃 버튼 클릭 시
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "로그아웃", message: "정말 로그아웃하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("ERROR: signout \(signOutError.localizedDescription)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

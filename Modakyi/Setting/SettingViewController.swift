//
//  SettingViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/02.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import SafariServices
import MessageUI
import GoogleMobileAds

class SettingViewController: UIViewController {
    let ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var notificationSettingButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var usewayButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var updatedVersionLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/4042418339"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        currentVersionLabel.text = "현재 버전 : \(self.getCurrentVersion())"
        updatedVersionLabel.text = "최신 버전 : \(self.getUpdatedVersion())"
        
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
        presentNoticeViewController(self)
    }
    
    // 문의 및 의견 버튼 클릭 시
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                             이곳에 내용을 작성해주세요.
                             
                             오타 발견 문의 시 아래 양식에 맞춰 작성해주세요.
                             
                             <예시>
                             글귀 ID : 글귀 4 (글귀 클릭 시 상단에 표시)
                             수정 전 : 실수해도 되.
                             수정 후 : 실수해도 돼.
                             
                             -------------------
                             
                             Device Model : \(self.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(self.getCurrentVersion())
                             
                             -------------------
                             """
            
            composeViewController.setToRecipients(["modakyi.help@gmail.com"])
            composeViewController.setSubject("<모닥이> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    // 이용방법 버튼 클릭 시
    @IBAction func usewayButtonTapped(_ sender: UIButton) {
        presentTutorialViewController(self)
        
    }
    
    // 로그아웃 버튼 클릭 시
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let isAnonymous = Auth.auth().currentUser?.isAnonymous
        let alertController = UIAlertController(title: "로그아웃", message: "정말 로그아웃하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 익명 유저이면 유저 데이터 삭제하고 로그인 화면으로 이동하기
            if isAnonymous! {
                self.ref.child("User/\(self.uid!)").removeValue()
                Auth.auth().currentUser?.delete(completion: { error in
                    if let error = error {
                        print("ERROR: CurrentUser Delete\(error.localizedDescription) ")
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            } else {
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                } catch let signOutError as NSError {
                    print("ERROR: signout \(signOutError.localizedDescription)")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    // 최신 버전 가져오기
    func getUpdatedVersion() -> String {
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.alswl.Modakyi"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
                  results.count > 0,
            let appStoreVersion = results[0]["version"] as? String else { return "" }
        return appStoreVersion
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

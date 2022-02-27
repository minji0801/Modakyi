//
//  SettingViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/02.
//  설정 ViewController

import UIKit
import Kingfisher
import MessageUI
import GoogleMobileAds

final class SettingViewController: UIViewController {
    let viewModel = SettingViewModel()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var updatedVersionLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/4042418339"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        // Version
        currentVersionLabel.text = "현재 버전 : \(viewModel.getCurrentVersion())"
        updatedVersionLabel.text = "최신 버전 : \(viewModel.getUpdatedVersion())"

        // Profile Image, UserName
        nameLabel.text = viewModel.getUserDisplayName()
        profileImage.kf.setImage(
            with: viewModel.getUserPhotoUrl(),
            placeholder: UIImage(systemName: "person.crop.circle")
        )
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }

    /// 화면 보여질 때마다: 다크모드 확인
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    /// 뒤로가기 버튼 클릭: 이전 화면(홈)으로
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    /// 알림설정 버튼 클릭: 설정앱으로 이동
    @IBAction func notificationSettingButtonTapped(_ sender: UIButton) {
        viewModel.goToSettings()
    }

    /// 다크모드 버튼 클릭: 설정한 값 저장하고 반영하기
    @IBAction func darckModeButtonTapped(_ sender: UIButton) {
        viewModel.setAppearance(self)
        self.viewWillAppear(true)
    }

    /// 공지사항 버튼 클릭: 공지사항 화면 보여주기
    @IBAction func noticeButtonTapped(_ sender: UIButton) {
        presentNoticeViewController(self)
    }

    /// 문의 및 의견 버튼 클릭: Mail 앱으로 이메일 작성
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients(["modakyi.help@gmail.com"])
            composeViewController.setSubject("<모닥이> 문의 및 의견")
            composeViewController.setMessageBody(viewModel.commentsBodyString(), isHTML: false)
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            self.presentToFailureSendMailAlert()
        }
    }

    /// 메일 보내기 실패 Alert 띄우기
    func presentToFailureSendMailAlert() {
        let sendMailErrorAlert = viewModel.sendMailFailAlert()
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    // 앱 평가
    @IBAction func reviewButtonTapped(_ sender: Any) {
        viewModel.goToStore()
    }

    // 이용방법
    @IBAction func usewayButtonTapped(_ sender: UIButton) {
        presentTutorialViewController(self)
    }

    /// 로그아웃 버튼 클릭: 로그아웃 진행
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = viewModel.logoutAlert(self)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MailComposeViewController Delegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    // (피드백 보내기) 메일 보낸 후
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true, completion: nil)
    }
}

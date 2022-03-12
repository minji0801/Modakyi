//
//  SettingTableViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  설정 화면

import UIKit
import MessageUI

final class SettingTableViewController: UITableViewController {
    let viewModel = SettingViewModel()

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        tableview.addGestureRecognizer(swipeLeft)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.isHidden = false
    }

    /// 셀 선택 시 바로 선택 해제하기
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        switch indexPath {
        case [0, 0]:    // 알림 설정
            viewModel.goToSettings()
        case [1, 0]:    // 공지사항
            pushToNoticeViewController(self)
        case [1, 1]:    // 문의 및 의견
            self.sendMail()
        case [1, 2]:    // 앱 평가
            viewModel.goToStore("모닥이")
        case [1, 3]:    // 이용방법
            presentTutorialViewController(self)
        case [1, 4]:    // 버전 정보
            pushToVersionViewController(self)
        case [2, 0]:    // 계정 정보
            pushToAccountViewController(self)
        case [2, 1]:    // 로그아웃
            let alertController = viewModel.logoutAlert(self)
            self.present(alertController, animated: true, completion: nil)
        case [3, 0]:    // Scoit
            viewModel.goToStore("Scoit")
        case [3, 1]:    // h:ours
            viewModel.goToStore("h:ours")
        default:
            print("Cell Clicked!", indexPath)
        }
    }

    /// 메일 보내기
    private func sendMail() {
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
    private func presentToFailureSendMailAlert() {
        let sendMailErrorAlert = viewModel.sendMailFailAlert()
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}

// MARK: - Configure TableView Section
extension SettingTableViewController {

    /// 섹션 수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    /// 섹션 타이틀
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = ["설정", "지원", "계정", "ⓒ Minji Kim"]
        return sectionHeader[section]
    }

    /// 섹션 뷰 구성
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 20, width: 150, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(titleLabel)

        return headerView
    }
}

// MARK: - Configure TableView Cell
extension SettingTableViewController {

    /// 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRow = [3, 5, 2, 2]
        return numRow[section]
    }

    /// 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath == [2, 0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovigCell", for: indexPath)
                    as? MovingCell else { return UITableViewCell() }
            cell.updateUI(indexPath)
            return cell
        } else if indexPath == [2, 1] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
                    as? LogoutCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
                    as? AppCell else { return UITableViewCell() }
            cell.updateUI(indexPath)
            return cell
        }
    }
}

// MARK: - @objc Function
extension SettingTableViewController {
    @objc func swipeLeft() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - MailComposeViewController Delegate
extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    // (피드백 보내기) 메일 보낸 후
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true, completion: nil)
    }
}

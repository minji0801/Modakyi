//
//  SettingTableViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  설정 TableViewController

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
        appearanceCheck(self)
        navigationItem.title = "설정"
        navigationController?.navigationBar.isHidden = false
    }

    /// 셀 선택 시
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath {
        case [0, 0]: viewModel.goToSettings()   // 알림 설정
        case [0, 1]: pushToThemeViewController(self)    // 테마 변경
        case [0, 2]: pushToFontViewController(self) // 글씨체 변경
        case [1, 0]: pushToNoticeViewController(self)   // 공지사항
        case [1, 1]: sendMail() // 문의 및 의견
        case [1, 2]: viewModel.goToStore("모닥이") // 앱 평가
        case [1, 3]: presentTutorialViewController(self)    // 이용방법
        case [1, 4]: pushToVersionViewController(self)  // 버전 정보
        case [2, 0]: pushToAccountViewController(self)  // 계정 정보
        case [2, 1]: present(viewModel.logoutAlert(self), animated: true)   // 로그아웃
        case [3, 0]: viewModel.goToStore("Scoit")   // Scoit
        case [3, 1]: viewModel.goToStore("h:ours")  // h:ours
        default: break
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
            present(composeViewController, animated: true)
        } else {
            presentToFailureSendMailAlert()
        }
    }

    /// 메일 보내기 실패 Alert 띄우기
    private func presentToFailureSendMailAlert() {
        let sendMailErrorAlert = viewModel.sendMailFailAlert()
        present(sendMailErrorAlert, animated: true)
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
            cell.updateUI(indexPath.row)
            return cell
        }
    }
}

// MARK: - @objc Function
extension SettingTableViewController {
    @objc func swipeLeft() {
        navigationController?.popViewController(animated: true)
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
        dismiss(animated: true)
    }
}

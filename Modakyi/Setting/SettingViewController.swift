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
//    @IBOutlet weak var darkmodeSwitch: UISwitch!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        // Navigation Bar Configure
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "설정"
        
        // Profile Image / UserName
        let username = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "User"
        let profileImg = Auth.auth().currentUser?.photoURL ?? URL(string: "")

        nameLabel.text = username
        profileImage.kf.setImage(with: profileImg, placeholder: UIImage(systemName: "person.crop.circle"))
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
        if appearance == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    @objc func darkmodeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        } else {
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
        self.tableview.reloadData()
        self.viewWillAppear(true)
    }
}


// MARK: - UITableView Configure
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let noticeCell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell else { return UITableViewCell() }
            return noticeCell
        case 1:
            guard let darkModeCell = tableView.dequeueReusableCell(withIdentifier: "DarkModeCell", for: indexPath) as? DarkModeCell else { return UITableViewCell() }
            darkModeCell.darkmodeSwitch.addTarget(self, action: #selector(self.darkmodeSwitchChanged(_:)), for: .valueChanged)
            return darkModeCell
        case 2:
            guard let usewayCell = tableView.dequeueReusableCell(withIdentifier: "UsewayCell", for: indexPath) as? UsewayCell else { return UITableViewCell() }
            return usewayCell
        case 3:
            guard let versionInfoCell = tableView.dequeueReusableCell(withIdentifier: "VersionInfoCell", for: indexPath) as? VersionInfoCell else { return UITableViewCell() }
            return versionInfoCell
        case 4:
            guard let signOutCell = tableView.dequeueReusableCell(withIdentifier: "SignOutCell", for: indexPath) as? SignOutCell else { return UITableViewCell() }
            return signOutCell
        default:
            return UITableViewCell()
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            // 이용방법
            let url = NSURL(string: "https://midi-dill-147.notion.site/3a762cd2888e40f08e392f31667020ff")
            let safariView: SFSafariViewController = SFSafariViewController(url: url! as URL)
            self.present(safariView, animated: true, completion: nil)
        case 4:
            // 로그아웃
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
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

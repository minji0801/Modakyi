//
//  SettingTableViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  설정 화면

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "설정"
    }

    // MARK: - Table view data source


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

//
//  ThanksTableViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/15.
//  Thanks 화면

import UIKit

final class ThanksTableViewController: UITableViewController {

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Thanks ❤️"

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        tableview.addGestureRecognizer(swipeLeft)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }
}

// MARK: - Configure TableView Section
extension ThanksTableViewController {
    
    /// 섹션 수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    /// 섹션 타이틀
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = ["Texts - Instagram", "Fonts - 눈누", "Icons - Iconfinder", "Others who helped"]
        return sectionHeader[section]
    }

    /// 섹션 뷰 구성
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 20, width: 200, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(titleLabel)

        return headerView
    }
}

// MARK: - Configure TableView Cell
extension ThanksTableViewController {

    /// 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRow = [8, 8, 3, 3]
        return numRow[section]
    }

    /// 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThanksTableViewCell", for: indexPath)
                as? ThanksTableViewCell else { return UITableViewCell() }

        cell.updateUI(indexPath)
        return cell
    }
}

// MARK: - @objc Function
extension ThanksTableViewController {
    @objc func swipeLeft() {
        navigationController?.popViewController(animated: true)
    }
}

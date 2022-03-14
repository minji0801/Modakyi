//
//  ThemeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/13.
//  테마 변경 ViewController

import UIKit

final class ThemeViewController: UIViewController {
    let viewModel = SettingViewModel()
    private lazy var theme = ThemeManager.currentTheme()

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "테마 변경"
        navigationItem.largeTitleDisplayMode = .never

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        view.addGestureRecognizer(swipeLeft)

        recommendView.layer.cornerRadius = 30

        let font = FontManager.currentFont()
        recommendLabel.font = font.iPhoneMediumFont
    }

    /// Appearance, Theme, Font 확인
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)

        theme = ThemeManager.currentTheme()
        backgroundView.backgroundColor = theme.backgroundColor
        recommendView.backgroundColor = theme.secondaryColor
        tableview.reloadData()
    }
}

// MARK: - TableView DataSoure & Delegate
extension ThemeViewController: UITableViewDataSource, UITableViewDelegate {

    /// 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell")
                as? ThemeTableViewCell else { return UITableViewCell() }

        if indexPath.row == theme.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        cell.updateUI(indexPath.row)
        return cell
    }

    /// 셀 선택 시 (Appearance랑 Theme 따로 저장)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.setAppearance(indexPath.row)
        viewModel.setTheme(indexPath.row)
        self.viewWillAppear(true)
    }
}

// MARK: - @objc Function
extension ThemeViewController {
    @objc func swipeLeft() {
        navigationController?.popViewController(animated: true)
    }
}

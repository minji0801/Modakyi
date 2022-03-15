//
//  FontViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/14.
//  글씨체 변경 ViewController

import UIKit

final class FontViewController: UIViewController {
    let viewModel = SettingViewModel()
    private lazy var font = FontManager.currentFont()

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "글씨체 변경"
        navigationItem.largeTitleDisplayMode = .never

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        view.addGestureRecognizer(swipeLeft)

        recommendView.layer.cornerRadius = 30

        let theme = ThemeManager.currentTheme()
        backgroundView.backgroundColor = theme.backgroundColor
        recommendView.backgroundColor = theme.secondaryColor
    }

    /// Appearance, Theme, Font 확인
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)

        font = FontManager.currentFont()
        recommendLabel.font = font.iPhoneMediumFont
        tableview.reloadData()
    }
}

// MARK: - TableView DataSoure & Delegate
extension FontViewController: UITableViewDataSource, UITableViewDelegate {

    /// 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FontTableViewCell")
                as? FontTableViewCell else { return UITableViewCell() }

        if indexPath.row == font.rawValue {
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
        viewModel.setFont(indexPath.row)
        viewWillAppear(true)
    }
}

// MARK: - @objc Function
extension FontViewController {
    @objc func swipeLeft() {
        navigationController?.popViewController(animated: true)
    }
}

//
//  VersionViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  버전 정보 ViewController

import UIKit

class VersionViewController: UIViewController {
    let viewModel = SettingViewModel()

    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var updatedVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        currentVersionLabel.text = "현재 버전 : \(viewModel.getCurrentVersion())"
        updatedVersionLabel.text = "최신 버전 : \(viewModel.getUpdatedVersion())"
    }

    /// 화면 pop
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    /// 업데이트 하러 가기
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        viewModel.goToStore("모닥이")
    }
}

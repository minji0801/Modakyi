//
//  VersionViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  버전 정보 ViewController

import UIKit

class VersionViewController: UIViewController {
    let viewModel = SettingViewModel()
    private let font = FontManager.currentFont()

    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var updatedVersionLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = true

        currentVersionLabel.text = "현재 버전 : \(viewModel.getCurrentVersion())"
        updatedVersionLabel.text = "최신 버전 : \(viewModel.getUpdatedVersion())"

        // 아이패드는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            currentVersionLabel.font = font.iPadMediumFont
            updatedVersionLabel.font = font.iPadMediumFont
            updateButton.titleLabel?.font = font.iPadMediumFont
        } else {
            currentVersionLabel.font = font.iPhoneMediumFont
            updatedVersionLabel.font = font.iPhoneMediumFont
            updateButton.titleLabel?.font = font.iPhoneMediumFont
        }
    }

    /// 화면 pop
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    /// 업데이트 하러 가기
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        viewModel.goToStore("모닥이")
    }
}

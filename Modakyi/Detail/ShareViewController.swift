//
//  ShareViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/12/12.
//  공유하기 팝업 화면

import UIKit

final class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    @IBAction func textShareButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("TextShare"), object: nil, userInfo: nil)
        dismiss(animated: true)
    }
    @IBAction func imageShareButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ImageShare"), object: nil, userInfo: nil)
        dismiss(animated: true)
    }
}

//
//  NetworkViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/04.
//

import UIKit

class NetworkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let alertController = UIAlertController(
            title: "네트워크에 접속할 수 없습니다.",
            message: "네트워크 연결 상태를 확인해주세요.",
            preferredStyle: .alert
        )

        let endAction = UIAlertAction(title: "종료", style: .destructive) { [weak self] _ in
            // 앱 종료
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            // 설정앱 켜주기
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

        alertController.addAction(endAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

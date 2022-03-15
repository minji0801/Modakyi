//
//  NetworkViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/04.
//  네트워크 접속안됬을 때 보여줄 ViewController

import UIKit

final class NetworkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let alertController = UIAlertController(
            title: "네트워크에 접속할 수 없습니다.",
            message: "네트워크 연결 상태를 확인해주세요.",
            preferredStyle: .alert
        )

        let endAction = UIAlertAction(title: "종료", style: .default) { _ in
            // 앱 종료
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }

        alertController.addAction(endAction)
        present(alertController, animated: true)
    }

    /// 화면 보여질 때마다: 다크모드 체크하기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }
}

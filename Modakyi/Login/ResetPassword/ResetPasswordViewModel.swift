//
//  ResetPasswordViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/27.
//  비밀번호 재설정 ViewModel

import Foundation
import FirebaseAuth

final class ResetPasswordViewModel {

    /// 비밀번호 재설정 메일 보내기
    func sendPasswordReset(_ email: String, completion: @escaping (UIAlertController) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in

            if error != nil {
                // 에러 발생 Alert
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: .alert
                )

                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(confirmAction)
                completion(alert)
            } else {
                // 메일 전송 완료 Alert
                let alert = UIAlertController(
                    title: "",
                    message: "메일을 전송했습니다. 비밀번호를 변경해주세요.",
                    preferredStyle: .alert
                )

                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(confirmAction)
                completion(alert)
            }
        }
    }
}

//
//  EnterEmailViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/27.
//  이메일 로그인 ViewModel

import Foundation
import FirebaseAuth

final class EnterEmailViewModel {

    /// Indicator 보여주기
    func showIndicator(_ viewController: EnterEmailViewController) {
        viewController.indicatorView.isHidden = false
    }

    /// Indicator 숨기기
    func hideIndicator(_ viewController: EnterEmailViewController) {
        viewController.indicatorView.isHidden = true
    }

    /// 신규 사용자 생성
    func createUser(_ email: String, _ password: String, completion: @escaping (String, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때 로그인하기
                    completion("signin", error)
                default:
                    completion("error", error)
                }
            } else {
                completion("signup", error)
            }
        }
    }

    /// 이메일 로그인
    func loginUser(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, error)
            }
        }
    }
}

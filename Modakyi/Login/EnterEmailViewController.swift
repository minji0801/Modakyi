//
//  EnterEmailViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EnterEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false

        emailTextField.delegate = self
        passwordTextField.delegate = self

        emailTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        self.indicatorView.isHidden = false

        // Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    // 로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.indicatorView.isHidden = true
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                // 사용자 데이터 저장하고 메인으로 이동
                setValueCurrentUser()
                showMainVCOnNavigation(self)
            }
        }
    }

    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                // 사용자 데이터 저장하고 메인으로 이동
                setValueCurrentUser()
                showMainVCOnNavigation(self)
            }
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    // 키보드 내려가게 할 때 사용할 delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }

    // 이메일과 비밀번호에 입력값이 있는지 확인해서 '다음' 버튼을 활성화 시켜주기 위한 delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}

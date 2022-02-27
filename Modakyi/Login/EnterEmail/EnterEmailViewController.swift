//
//  EnterEmailViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//  이메일 로그인 ViewController

import UIKit

final class EnterEmailViewController: UIViewController {
    let viewModel = EnterEmailViewModel()

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

    /// 화면 보여질 때마다: 다크모드 확인, 네비게이션 바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = false
    }

    /// 다음 버튼 클릭: 로그인 또는 회원가입 진행
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.showIndicator(self)

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        viewModel.createUser(email, password) { [weak self] status, error in
            guard let self = self else { return }

            switch status {
            case "signin":
                self.loginUser(withEmail: email, password: password)
            case "signup":
                // 사용자 데이터 저장하고 메인으로 이동
                setValueCurrentUser()
                showMainVCOnNavigation(self)
            case "error":
                self.viewModel.hideIndicator(self)
                self.errorMessageLabel.text = error?.localizedDescription
            default: break
            }
        }
    }

    /// 이메일 로그인 진행
    private func loginUser(withEmail email: String, password: String) {
        viewModel.loginUser(withEmail: email, password: password) { [weak self] login, error in
            guard let self = self else { return }

            if login {  // 사용자 데이터 저장하고 메인으로 이동
                setValueCurrentUser()
                showMainVCOnNavigation(self)
            } else {    // 에러 보여주기
                self.viewModel.hideIndicator(self)
                self.errorMessageLabel.text = error?.localizedDescription
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

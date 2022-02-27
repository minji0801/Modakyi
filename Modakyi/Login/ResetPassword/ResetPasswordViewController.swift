//
//  ResetPasswordViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/18.
//  비밀번호 재설정 ViewController

import UIKit

final class ResetPasswordViewController: UIViewController {
    let viewModel = ResetPasswordViewModel()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceCheck(self)

        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        resetPasswordButton.isEnabled = false
    }

    /// 화면 터치: 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /// X 버튼 클릭: 화면 닫기
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    /// 비밀번호 재설정 버튼 클릭
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = self.emailTextField.text ?? ""
        viewModel.sendPasswordReset(email) { [weak self] alert in
            guard let self = self else { return }

            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - TextField Delegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        resetPasswordButton.isEnabled = !isEmailEmpty
    }
}

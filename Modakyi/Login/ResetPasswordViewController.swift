//
//  ResetPasswordViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/18.
//

import UIKit
import FirebaseAuth
import Accelerate

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceCheck(self)

        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        resetPasswordButton.isEnabled = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = self.emailTextField.text ?? ""
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }

            if error != nil {
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: .alert
                )

                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(
                    title: "",
                    message: "메일을 전송했습니다. 비밀번호를 변경해주세요.",
                    preferredStyle: .alert
                )

                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

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

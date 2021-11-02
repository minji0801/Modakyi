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
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
        if appearance == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        // Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    // 로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                // 사용자 데이터 저장하고 메인으로 이동
                let uid = Auth.auth().currentUser?.uid
                self.ref.child("User/\(uid!)/displayName").setValue(Auth.auth().currentUser?.displayName ?? "")
                self.ref.child("User/\(uid!)/email").setValue(Auth.auth().currentUser?.email ?? "")
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                // 사용자 데이터 저장하고 메인으로 이동
                let uid = Auth.auth().currentUser?.uid
                self.ref.child("User/\(uid!)/displayName").setValue(Auth.auth().currentUser?.displayName ?? "")
                self.ref.child("User/\(uid!)/email").setValue(Auth.auth().currentUser?.email ?? "")
                self.showMainViewController()
            }
        }
    }
}
extension EnterEmailViewController: UITextFieldDelegate {
    // 키보드 내려가게 할 때 사용할 delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 이메일과 비밀번호에 입력값이 있는지 확인해서 '다음' 버튼을 활성화 시켜주기 위한 delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}

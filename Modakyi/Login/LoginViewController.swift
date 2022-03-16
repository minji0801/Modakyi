//
//  LoginViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//  로그인 ViewController

import UIKit
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()

    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.cornerRadius = 28
        }

        // 앱을 처음 실행했다면 튜토리얼 화면 띄워주기
        if !UserDefaults.standard.bool(forKey: "Tutorial") {
            presentTutorialViewController(self)
        }

        // 현재 로그인한 사용자 있으면 바로 메인화면으로 이동
        if viewModel.currentUser() != nil {
            showMainVCOnRoot()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        GIDSignIn.sharedInstance().presentingViewController = self  // Google Sign In
        navigationController?.navigationBar.isHidden = true
    }

    /// 구글 로그인 버튼 클릭
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    /// 애플 로그인 버튼 클릭
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        viewModel.startSignInWithAppleFlow(self)
    }

    /// 로그인 건너뛰기 버튼 클릭
    @IBAction func loginSkipButtonTapped(_ sender: UIButton) {
        let alertController = viewModel.anonymousLoginAlert(self) { [weak self] in
            guard let self = self else { return }

            // 유저 데이터 만들고 메인으로 이동하기
            setValueCurrentUser()
            showMainVCOnNavigation(self)

            // Hide Indicator
            self.viewModel.hideIndicator(self)
        }
        present(alertController, animated: true)
    }
}

// MARK: - Apple Login Configure
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화된 임의의 난수
             - 단 한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
             - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
             */
            guard let nonce = viewModel.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            // Show Indicator
            viewModel.showIndicator(self)

            viewModel.signInAppleUser(idTokenString, nonce) { [weak self] in
                guard let self = self else { return }

                // Apple Login User 데이터 만들고 메인으로 이동
                setValueCurrentUser()
                showMainVCOnNavigation(self)

                // Hide Indicator
                self.viewModel.hideIndicator(self)
            }
        }
    }
}

// MARK: - ASAuthorizationController Present Delegate
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

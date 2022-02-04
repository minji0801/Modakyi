//
//  LoginViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import FirebaseDatabase
import SystemConfiguration

class LoginViewController: UIViewController {
    private var currentNonce: String?
    var ref: DatabaseReference!
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 0.2
            $0?.layer.borderColor = UIColor.darkGray.cgColor
            $0?.layer.cornerRadius = 28
        }
        
        // 앱을 처음 실행했다면 바로 튜토리얼 화면으로 이동
        if !UserDefaults.standard.bool(forKey: "Tutorial") {
            showTutorialVCOnRoot()
        }
        
        // 현재 로그인한 사용자 있으면 바로 메인화면으로 이동
        if let _ = Auth.auth().currentUser {
            showMainVCOnRoot()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance().presentingViewController = self  // Google Sign In
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        startSignInWithAppleFlow()
    }
    
    @IBAction func loginSkipButtonTapped(_ sender: UIButton) {
        // Alert띄우기
        let alert = UIAlertController(title: "경고", message: "계정 없이 앱을 이용하는 경우, 앱에서 로그아웃할 때 해당 데이터가 삭제됩니다. 진행하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 익명 데이터 생성
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print ("Error Anonymously sign in: %@", error)
                    return
                }
                
                // 유저 데이터 만들고 메인으로 이동하기
                SetValueCurrentUser()
                showMainVCOnNavigation(self)
                
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Apple Login Configure

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화된 임의의 난수
             - 단 한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
             - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
             */
            guard let nonce = currentNonce else {
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
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                
                // Apple Login User 데이터 만들기
                SetValueCurrentUser()
                showMainVCOnNavigation(self)
            }
        }
    }
}

//Apple Sign in
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//
//  LoginViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/27.
//  로그인 ViewModel

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

final class LoginViewModel: NSObject {
    var currentNonce: String?

    /// 현재 사용자
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }

    /// Indicator 보여주기
    func showIndicator(_ viewController: LoginViewController) {
        viewController.indicatorView.isHidden = false
    }

    /// Indicator 숨기기
    func hideIndicator(_ viewController: LoginViewController) {
        viewController.indicatorView.isHidden = true
    }

    /// 익명 로그인 Alert 창
    func anonymousLoginAlert(
        _ viewController: LoginViewController,
        completion: @escaping () -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: "로그인 건너뛰기",
            message: "로그아웃 또는 앱 삭제 시 데이터가 삭제될 수 있습니다. 진행하시겠습니까?",
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }

            // Show Indicator
            self.showIndicator(viewController)

            // 익명 데이터 생성
            Auth.auth().signInAnonymously { _, error in
                if let error = error {
                    print("Error Anonymously sign in: %@", error)
                    return
                }
                completion()
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        return alertController
    }

    /// 애플 로그인 시작
    func startSignInWithAppleFlow(_ viewController: LoginViewController) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController
        authorizationController.presentationContextProvider = viewController
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

    /// 랜덤한 난수 만들기
    /// https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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

    /// 애플 계정으로 로그인하기
    func signInAppleUser(_ idTokenString: String, _ nonce: String, completion: @escaping () -> Void) {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString, rawNonce: nonce
        )

        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                print("Error Apple sign in: %@", error)
                return
            }
            completion()
        }
    }
}

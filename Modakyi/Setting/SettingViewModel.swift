//
//  SettingViewModel.swift
//  Modakyi
//
//  Created by 김민지 on 2022/02/26.
//  설정 ViewModel

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class SettingViewModel {
    private let ref: DatabaseReference! = Database.database().reference()
    private let uid = Auth.auth().currentUser?.uid

    /// 사용자  이미지 url 가져오기
    func getUserPhotoUrl() -> URL? {
        return Auth.auth().currentUser?.photoURL ?? URL(string: "")
    }

    /// 사용자 닉네임 가져오기
    func getUserDisplayName() -> String {
        return Auth.auth().currentUser?.displayName ?? ""
    }

    /// 사용자 이메일 가져오기
    func getUserEmail() -> String {
        return Auth.auth().currentUser?.email ?? ""
    }

    /// 사용자 로그인 방식 가져오기
    func getUserProviderID() -> String {
        let user = Auth.auth().currentUser
        var providerID = ""
        if let user = user {
            if !user.providerData.isEmpty {
                providerID = user.providerData[0].providerID
            } else {
                return "익명 로그인"
            }
        }

        switch providerID {
        case "google.com":
            return "Google 로그인"
        case "apple.com":
            return "Apple 로그인"
        case "password":
            return "이메일 로그인"
        default:
            return ""
        }
    }

    /// 설정-알림 화면으로 이동
    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    /// Appearance 저장
    func setAppearance(_ row: Int) {
        switch row {
        case 1:
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        default:
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
    }

    /// 테마 저장
    func setTheme(_ row: Int) {
        switch row {
        case 0: ThemeManager.applyTheme(theme: .white)
        case 1: ThemeManager.applyTheme(theme: .black)
        case 2: ThemeManager.applyTheme(theme: .rolling)
        case 3: ThemeManager.applyTheme(theme: .lemon)
        case 4: ThemeManager.applyTheme(theme: .undergrowth)
        case 5: ThemeManager.applyTheme(theme: .lily)
        case 6: ThemeManager.applyTheme(theme: .bubbly)
        case 7: ThemeManager.applyTheme(theme: .meeting)
        default: break
        }
    }

    /// 폰트 저장
    func setFont(_ row: Int) {
        switch row {
        case 0: FontManager.applyFont(font: .elice)
        case 1: FontManager.applyFont(font: .nanumR)
        case 2: FontManager.applyFont(font: .nanumB)
        case 3: FontManager.applyFont(font: .nanumSquareR)
        case 4: FontManager.applyFont(font: .nanumSquareB)
        case 5: FontManager.applyFont(font: .gowunBatang)
        case 6: FontManager.applyFont(font: .gowunDodum)
        case 7: FontManager.applyFont(font: .gangwonAll)
        case 8: FontManager.applyFont(font: .kyobo2019)
        case 9: FontManager.applyFont(font: .kyobo2020)
        case 10: FontManager.applyFont(font: .uhbeeZziba)
        case 11: FontManager.applyFont(font: .leeseoyun)
        default : break
        }
    }

    /// 문의 및 의견 내용
    func commentsBodyString() -> String {
        return """
                이곳에 내용을 작성해주세요.

                오타 발견 문의 시 아래 양식에 맞춰 작성해주세요.

                <예시>
                글귀 ID : 글귀 4 (글귀 클릭 시 상단에 표시)
                수정 전 : 실수해도 되.
                수정 후 : 실수해도 돼.

                -------------------

                Device Model : \(getDeviceIdentifier())
                Device OS : \(UIDevice.current.systemVersion)
                App Version : \(getCurrentVersion())

                -------------------
                """
    }

    /// 메일 전송 실패 Alert
    func sendMailFailAlert() -> UIAlertController {
        let sendMailErrorAlert = UIAlertController(
            title: "메일 전송 실패",
            message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
            preferredStyle: .actionSheet
        )

        let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
            // 앱스토어로 이동하기(Mail)
            let store = "https://apps.apple.com/kr/app/mail/id1108187098"
            if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)

        sendMailErrorAlert.addAction(goAppStoreAction)
        sendMailErrorAlert.addAction(cancleAction)
        return sendMailErrorAlert
    }

    /// 앱스토어로 이동
    func goToStore(_ appName: String) {
        var store = ""
        switch appName {
        case "모닥이":
            store = "https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726"
        case "Scoit":
            store = "https://apps.apple.com/kr/app/scoit/id1576850548"
        case "h:ours":
            store = "https://apps.apple.com/kr/app/h-ours/id1605524722"
        default:
            break
        }

        if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    /// 익명 사용자 로그아웃
    func anonymousLogout(_ viewController: UIViewController) {
        ref.child("User/\(uid!)").removeValue()
        Auth.auth().currentUser?.delete(completion: { error in
            if let error = error {
                print("ERROR: CurrentUser Delete\(error.localizedDescription) ")
            } else {
                viewController.navigationController?.popToRootViewController(animated: true)
            }
        })
    }

    /// 일반 사용자 로그아웃
    func generalLogout(_ viewController: UIViewController) {
        do {
            try Auth.auth().signOut()
            viewController.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }

    /// 로그아웃 Alert 창
    func logoutAlert(_ viewController: UIViewController) -> UIAlertController {
        let isAnonymous = Auth.auth().currentUser?.isAnonymous
        let alertController = UIAlertController(
            title: "로그아웃",
            message: "정말 로그아웃하시겠습니까?",
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if isAnonymous! {    // 익명 사용자 로그아웃
                self.anonymousLogout(viewController)
            } else {    // 일반 사용자 로그아웃
                self.generalLogout(viewController)
            }
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .destructive, handler: nil)

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        return alertController
    }

    /// 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }

    /// 최신 버전 가져오기
    func getUpdatedVersion() -> String {
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.alswl.Modakyi"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
                  results.count > 0,
            let appStoreVersion = results[0]["version"] as? String else { return "" }
        return appStoreVersion
    }

    /// 기기 Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

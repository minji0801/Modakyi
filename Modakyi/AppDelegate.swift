//
//  AppDelegate.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit
import Firebase
//import GoogleSignIn
import FirebaseDatabase
import UserNotifications
import FirebaseMessaging
import Siren

//, GIDSignInDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var ref: DatabaseReference!
    var shouldSupportAllOrientation = true
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible() // 이 메소드가 반드시 선행되어야함.
        
        let siren = Siren.shared
        siren.apiManager = APIManager(country: .korea)  // 기준 위치 대한민국 앱스토어로 변경
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .korean) // 알림 메시지 한국어로
        siren.wail()    // 업데이트 알림 동작
        
        Thread.sleep(forTimeInterval: 0.5)
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        // FCM 현재 등록 토큰 확인
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR FCM 등록 토큰 가져오기: \(error.localizedDescription)")
            } else if token == token {
                print("FCM 등록 토큰: \(token)")
            }
        }
        
        // User Notification 설정 및 사용자 동의 얻기
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { didAllow, error in
            if didAllow {
                print("Push 알림 권한 허용")
            } else {
                print("Push 알림 권한 거부: \(error.debugDescription)")
            }
        }
        application.registerForRemoteNotifications()
        
        // Google 로그인 Delgate
        //        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //        GIDSignIn.sharedInstance().delegate = self
        
        NetworkCheck.shared.startMonitoring()
        return true
    }
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        // 구글의 인증 프로세스가 끝날 때 앱이 수신하는 url 처리
    //        return GIDSignIn.sharedInstance().handle(url)
    //    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        exit(0)
    }
    
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        // Google 로그인 인증 후 전달된 값을 처리하는 부분
    //        if let error = error {
    //            print("ERROR Google Sign In \(error.localizedDescription)")
    //            return
    //        }
    //
    //        guard let authentication = user.authentication else { return }
    //        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    //
    //        Auth.auth().signIn(with: credential) { _, _ in
    //            // Google Login User 데이터 만들기
    //            SetValueCurrentUser()
    //            showMainVCOnRoot()
    //        }
    //    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound]) // 알림 display 형태 지정
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // 다시 토큰 받았는지 확인
        guard let fcmToken = fcmToken else { return }
        print("FCM 등록 토큰 갱신: \(fcmToken)")
    }
}

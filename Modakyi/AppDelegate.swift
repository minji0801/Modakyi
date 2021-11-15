//
//  AppDelegate.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var ref: DatabaseReference!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        NetworkCheck.shared.startMonitoring()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 구글의 인증 프로세스가 끝날 때 앱이 수신하는 url 처리
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        exit(0)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Google 로그인 인증 후 전달된 값을 처리하는 부분
        if let error = error {
            print("ERROR Google Sign In \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { _, _ in
            // Google Login User 데이터 만들기
            self.ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            self.ref.child("User/\(uid!)/displayName").setValue(Auth.auth().currentUser?.displayName ?? "")
            self.ref.child("User/\(uid!)/email").setValue(Auth.auth().currentUser?.email ?? "")
            
            // Main 화면으로 이동
            self.showMainViewController()
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
    }
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

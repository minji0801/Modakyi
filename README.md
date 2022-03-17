<div align="center">
  
  <!-- Header -->
  ![header](https://capsule-render.vercel.app/api?type=waving&color=E76140&height=250&section=header&text=모닥이&desc=글귀%20%2F%20명언%20모음%20앱&descAlignY=55&fontSize=70&fontAlignY=35&fontColor=FFFFFF)
  
  모닥불 앞에 있으면 몸이 따뜻해지듯이, 모닥이가 당신의 마음을 따뜻하게 어루만져 주길.
  
  <br/>
  
  ### Modakyi : Sayings Collection App
  Like getting warm in front of a bonfire, Hope Modakyi warms your heart.
  
  <br/>
  
  <!-- Badge -->
  ![version](https://img.shields.io/badge/v-1.5.0-brightgreen?style=flat-square)
  ![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
  ![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=Firebase&logoColor=black)
  ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white)
  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)
  [![App Store](https://img.shields.io/badge/App%20Store-0D96F6?style=flat-square&logo=App%20Store&logoColor=white)](https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726)
  [![Notion](https://img.shields.io/badge/Notion-181717?style=flat-square&logo=Notion&logoColor=white)](https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7)
  [![Gmail](https://img.shields.io/badge/Gmail-EA4335?style=flat-square&logo=Gmail&logoColor=white)](https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=modakyi.help@gmail.com)
  
</div>

<!-- Navigation -->
## Navigation
1. [Motive](#Motive)
2. [Goals](#Goals)
3. [Login](#Login)
4. [Text Management](#Text-Management)
5. [Home](#Home)
6. [Detail](#-글귀-상세-보기)
7. [Favorite and Unused](#-좋아하는-글귀와-미사용-글귀)
8. [Search](#-글귀-검색)
9. [Settings](#-설정)
10. [Design](#Design)
11. [First Time](#First-Time)
12. [Meet](#Meet)
13. [History](#History)

<br/>

<!-- 1. Motive -->
## Motive
I find sayings on social media every day and write them down on my planner. It is cumbersome to look up every time, and there is a limit to remembering whether or not to use it. So I made a collection of sayings app, Modakyi.

<br/>

<!-- 2. Goals -->
## Goals
- Users can easily see the sayings in one space.
- Users can indicate whether they like or used the sayings, and view them separately.
- Every time the user accesses the app, recommend a random saying.

<br/>

<!-- 3. Login -->
## Login
When you access the app, the first screen you see is the login screen. If there is a currently logged in user, it moves to the main screen (home). There are 4 types of login, all using ```FirebaseAuth```. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Login)

<p align="left"><img alt="Login" width="200" src="https://user-images.githubusercontent.com/49383370/158805754-418696d8-d449-4df6-b2ae-d0fcb17c1d2a.png"></p>

> At first, only email, Google, and Apple logins were implemented, but Apple rejected the application saying that it should be possible to use the app without login. This is described in [App Store Review Guidelines 5.1.1(v)](https://developer.apple.com/kr/app-store/review/guidelines/#data-collection-and-storage).

<br/>

<!-- 4. Text Management -->
## Text Management
The text is stored and used in the following format. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Model)

```swift
struct StudyStimulateText: Codable {
    let id: String      // 글귀 아이디
    let kor: String     // 한글
    let eng: String     // 영어
    let who: String     // 글귀말한 사람(출처)
    let time: String    // 업로드 시간
}
```

<br/>

In fact, the text is stored in the Firebase ```RealtimeDatabase``` as follows. ```('Text' + textID)``` is used as a unique ID. One new text is added and managed every day.

<p align="left"><img alt="data" width="400" src="https://user-images.githubusercontent.com/49383370/155842262-955d605e-67d1-4357-8c71-5fbb3aaf8d47.png"></p>

<br/>

<!-- 5. Home -->
## Home
On the home screen, ```recommended text and all texts``` are displayed. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Home)

By accessing the Text path of Firebase RealitimeDatabase, the entire text is fetched, and a random value from the entire text is fetched as the recommended text ID. And if it is ```within two days``` from the upload time to today, it is classified as a new text.

```A red dot``` is displayed in the cell of the new text. If the user has already clicked, the red dot is not displayed.

<p align="left"><img alt="home" width="200" src="https://user-images.githubusercontent.com/49383370/158813134-1837fced-5410-47c6-8da0-608f631aba7d.png"></p>

<br/>

<!-- 6. 글귀 상세 보기 -->
## 👀 글귀 상세 보기
글귀를 클릭하면 내용을 크게 볼 수 있다. 그리고 해당 글귀의 좋아요, 사용 여부를 체크할 수 있고 텍스트나 이미지로 공유할 수 있다.

<br/>

<p align="center"><img alt="상세" src="https://user-images.githubusercontent.com/49383370/156298736-15b4c168-5090-4e95-8c41-168807106c55.png" width="200"></p>

<br/>

글귀 상세 화면을 보여줄 때 해당 글귀의 아이디를 넘겨주도록 구현했다.

<br/>

file: ShowViewController
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid = Auth.auth().currentUser?.uid

lazy var id = ""                // 글귀 아이디

/// DetailViewController를 present하기
func presentDetailViewController(_ viewController: UIViewController, _ textId: String) {
    guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController else { return }
    detailViewController.viewModel.id = textId  // 글귀 아이디 넘겨주기
    viewController.present(detailViewController, animated: true, completion: nil)
}
```

<br/>

그래서 이렇게 넘겨받은 id 값으로 글귀 정보를 가져온다.

<br/>

file DetailViewModel
```swift
// 글귀 가져오기
func getText(completion: @escaping (String, String, String) -> Void) {
    print("ViewModel 글귀 아이디: \(id)")

    ref.child("Text/Text\(id)").observe(.value) { snapshot in
        guard let value = snapshot.value as? [String: String] else { return }

        let eng = value["eng"]!
        let kor = value["kor"]!
        let who = value["who"]!
        completion(eng, kor, who)
    }
}
```

<br/>

좋아요와 사용 여부는 화면이 보여질 때마다(viewWillAppear) 체크한다. **User/(사용자uid)/like** 와 **User/(사용자uid)/used** 경로에 접근하여 각각 좋아하는 글귀의 아이디(likeTextIDs)와 사용한 글귀의 아이디(usedTextIDs)를 가져온다. 현재 글귀의 id가 여기에 포함되어있다면 버튼이 선택된 것으로 표현한다.

<br/>

file: DetailViewController
```swift
/// 버튼 설정
func setupButtons() {
    let id = viewModel.id
    likeButton.tag = Int(id)!
    checkButton.tag = Int(id)!

    if viewModel.likeTextIDs.contains(Int(id)!) {
        likeButton.isSelected = true
        likeButton.tintColor = .systemPink
    } else {
        likeButton.isSelected = false
        likeButton.tintColor = .label
    }

    if viewModel.usedTextIDs.contains(Int(id)!) {
        checkButton.isSelected = true
        checkButton.tintColor = .systemGreen
    } else {
        checkButton.isSelected = false
        checkButton.tintColor = .label
    }
}
```

<br/>

공유하기 화면은 텍스트 또는 이미지 버튼이 클릭되면 Noti를 받아와 해당 공유하기 화면을 보여주도록 구현했다.

<br/>

file: DetailViewController
```swift
/// 공유하기 화면 띄우기
func presentToActivityVC(items: [Any]) {
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = self.view
    activityVC.popoverPresentationController?.sourceRect = self.textView.bounds
    activityVC.popoverPresentationController?.permittedArrowDirections = .left
    DispatchQueue.main.async { [weak self ] in
        guard let self = self else { return }

        self.present(activityVC, animated: true, completion: nil)
    }
}

/// 텍스트 공유하기 버튼 클릭된 후 Noti
@objc func textShareNotification(_ notification: Notification) {
    var objectsToShare = [String]()
    if let text = self.textLabel.text {
        objectsToShare.append(text)
    }
    presentToActivityVC(items: objectsToShare)
}

/// 이미지 공유하기 버튼 클릭된 후 Noti
@objc func imageShareNotification(_ notification: Notification) {
    guard let image = self.textView.transfromToImage() else { return }
    presentToActivityVC(items: [image])
}
```

<br/>

<!-- 7. 좋아하는 글귀와 미사용 글귀 -->
## 📌 좋아하는 글귀와 미사용 글귀
아래 화면은 좋아하는 글귀모음이다. 사용자가 좋아요를 표시한 글귀만 모아볼 수 있는 공간이다. 

<br/>

<p align="center"><img alt="좋아요" src="https://user-images.githubusercontent.com/49383370/156298819-2e90bd94-fee7-4d1e-9f9c-06df325fe6bc.png" width="200"></p>

<br/>

**User/(사용자uid)/like** 경로에 접근하여 사용자가 좋아하는 글귀의 아이디를 가져온 후 CollectionView Cell에 뿌려준다.

<br/>

file: LikeViewModel
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid = Auth.auth().currentUser?.uid

lazy var likeTextIDs: [Int] = [] // 좋아하는 글귀 id

/// 좋아하는 글귀 아이디 가져오기
func getLikeTextIDs(completion: @escaping (Bool) -> Void) {
    ref.child("User/\(uid!)/like").observe(.value) { [weak self] snapshot in
        guard let self = self else { return }
        guard let value = snapshot.value as? [Int] else {
            // 좋아하는 글귀가 없음
            self.likeTextIDs = []
            completion(false)
            return
        }

        self.likeTextIDs = value.reversed()
        completion(true)
    }
}
```

<br/>

사용자가 아직 사용하지 않은 글귀만 모아볼 수 있는 미사용 글귀모음이다.

<br/>

<p align="center"><img alt="미사용" src="https://user-images.githubusercontent.com/49383370/156298850-4d41017f-55d3-477d-8ecc-9577c8db34c2.png" width="200"></p>

<br/>

**User/(사용자uid)/used** 경로에 접근하여 사용자가 사용한 글귀의 아이디와 반대된 값을 가져온 후 CollectionView Cell에 뿌려준다.

<br/>

file: UnusedViewModel
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid = Auth.auth().currentUser?.uid

lazy var unusedTextIDs = [Int]()  // 미사용 글귀 아이디
    
/// 사용자가 사용한 글귀 아이디 가져오기
func getUnusedTextIDs(completion: @escaping (Bool) -> Void) {
    ref.child("User/\(uid!)/used").observe(.value) { [weak self] snapshot in
        guard let self = self else { return }
        guard let value = snapshot.value as? [Int] else {
            // 사용한 글귀가 없음 -> 미사용 글귀 아이디 = 전체 글귀 아이디
            self.unusedTextIDs = self.fullText.map { Int($0.id)! }
            completion(false)
            return
        }

        self.unusedTextIDs = self.fullText.indices.filter { !(value.contains($0)) }.sorted(by: >)
        print("ViewModel 미사용 글귀 id: \(self.unusedTextIDs)")
        completion(true)
    }
}
```

<br/>

<!-- 8. 글귀 검색 -->
## 🔍 글귀 검색
글귀 검색화면에서 텍스트 값을 포함한 글귀를 찾을 수 있다. UISearchBarDelegate를 상속하여 SearchBar에 대한 작업을 구현했다.

<br/>

<p align="center"><img alt="검색" src="https://user-images.githubusercontent.com/49383370/156298893-54282bdc-40a1-4cb2-b730-299dacbe71ab.png" width="200"></p>

<br/>

검색어를 입력하고 검색 버튼을 클릭하면 **해당 검색어를 포함한 글귀를 filter 문을 통해 걸러내고** 검색 결과를 CollectionView에 보여준다.

<br/>

file: SearchViewController
```swift
/// 검색버튼 눌렀을 때
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()

    guard let searchWord = searchBar.text, searchWord.isEmpty == false else { return }
    print("검색어: \(searchWord)")

    viewModel.search(searchWord) {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            if self.viewModel.fullText.isEmpty {
                self.labelView.isHidden = false
            } else {
                self.labelView.isHidden = true
            }
            self.collectionview.reloadData()
        }
    }
}
```

<br/>

file: SearchViewModel
```swift
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()

lazy var fullText: [StudyStimulateText] = [] // 전체 글귀
    
/// 검색
func search(_ searchWord: String, completion: @escaping () -> Void) {
    ref.child("Text").observe(.value) { [weak self] snapshot in
        guard let self = self,
              let value = snapshot.value as? [String: [String: String]] else { return }

        let searchResult = value.filter {
            $0.value.contains {
                $0.value.contains(searchWord)
            }
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: searchResult)
            let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
            let texts = Array(textData.values)

            self.fullText = texts.sorted { Int($0.id)! > Int($1.id)! }
            print("ViewModel 검색결과: \(self.fullText)")
            completion()
        } catch let error {
            print("ERROR JSON Parsing \(error.localizedDescription)")
        }
    }
}
```

<br/>

<!-- 9. 설정 -->
## 🛠 설정

<br/>

<p align="center"><img alt="설정" src="https://user-images.githubusercontent.com/49383370/156298952-3d90e55c-942c-4867-b44b-e3d91bf9c6aa.png" width="200"></p>

<br/>

### 사용자 정보 가져오기
모닥이의 설정화면에서는 현재 로그인한 유저의 프로필 이미지와 닉네임을 확인할 수 있다. **FirebaseAuth**를 이용해서 현재 로그인한 사용자의 정보를 가져와 UI Component에 뿌려준다.

<br/>

file: SettingViewModel
```swift
import FirebaseAuth
private let uid = Auth.auth().currentUser?.uid

/// 사용자 닉네임 가져오기
func getUserDisplayName() -> String {
    return Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "User"
}

/// 사용자  이미지 url 가져오기
func getUserPhotoUrl() -> URL? {
    return Auth.auth().currentUser?.photoURL ?? URL(string: "")
}
```

<br/>

### 알림 설정
알림 설정의 경우 원래 다른 앱과 비슷하게 스위치 버튼을 통해 켜고 끄고가 가능하도록 구현하는 게 목표였지만 앱 내에서 설정의 값을 변경시키는 게 적용되지 않았고, 우선 설정화면으로 이동하는 것으로 구현했다. 

<br/>

file: SettingViewModel
```swift
/// 설정-알림 화면으로 이동
func goToSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
```

<br/>

### 다크 모드
UserDefaults를 이용해서 키가 **'Appearance'인 곳에 다크 모드를 저장**시켜놓고, ViewController의 viewWillAppear에서 호출되는 appearanceCheck() 함수를 통해서 현재 앱에 설정되어 있는 모드를 적용시키도록 구현했다.

<br/>

file: SettingViewModel
```swift
/// 다크모드 저장
func setAppearance(_ viewController: SettingViewController) {
    let appearance = UserDefaults.standard.string(forKey: "Appearance")
    // 처음엔 light: appearance 없음(nil)
    if appearance == nil || appearance! == "Light" {
        UserDefaults.standard.set("Dark", forKey: "Appearance")
    } else {
        UserDefaults.standard.set("Light", forKey: "Appearance")
    }
}
```

<br/>

file: SettingViewController
```swift
/// 화면 보여질 때마다: 다크모드 확인
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appearanceCheck(self)
}
```

<br/>

file: UIConfigure
```swift
/// UserDefaults에 저장된 값으로 다크모드 확인하기
func appearanceCheck(_ viewController: UIViewController) {
    guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }
    if appearance == "Dark" {
        viewController.overrideUserInterfaceStyle = .dark
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    } else {
        viewController.overrideUserInterfaceStyle = .light
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
```

<br/>

### 공지사항
공지사항은 말 그대로 사용자에게 간단한 공지나 앱 버전 업데이트 관련 내용을 보여주기 위한 화면이다.

<br/>

<p align="center"><img alt="공지" src="https://user-images.githubusercontent.com/49383370/156299028-3922cad8-6b3d-410b-bbe7-b673cfb88858.png" width="200"></p>

<br/>

### 문의 및 의견
MessageUI 프레임워크를 이용하여 Mail 앱을 통해 이메일을 작성하는 화면을 보여주고, 메일을 작성하여 개발자에게 보낼 수 있다. 메일 보내기에 실패한 경우 Alert 창을 띄워 사용자가 Mail 앱을 설치하거나 이메일 설정을 확인할 수 있도록 구현했다.

<br/>

file: SettingViewController
```swift
import MessageUI

    /// 문의 및 의견 버튼 클릭: Mail 앱으로 이메일 작성
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients(["modakyi.help@gmail.com"])
            composeViewController.setSubject("<모닥이> 문의 및 의견")
            composeViewController.setMessageBody(viewModel.commentsBodyString(), isHTML: false)
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            self.presentToFailureSendMailAlert()
        }
    }

    /// 메일 보내기 실패 Alert 띄우기
    func presentToFailureSendMailAlert() {
        let sendMailErrorAlert = viewModel.sendMailFailAlert()
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
```

<br/>

file: SettingViewModel
```swift
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
```

<br/>

### 앱 평가
'앱 평가' 버튼을 클릭하면 App Store 모닥이 앱 페이지로 이동하여 사용자가 앱을 평가할 수 있도록 구현했다.

<br/>

<p align="center"><img alt="앱스토어" src="https://user-images.githubusercontent.com/49383370/155327206-a27fa9e1-d877-460c-b3ba-03df8308386b.jpeg" width="200"></p>

<br/>

file: SettingViewModel
```swift
/// 모닥이 앱스토어로 이동
func goToStore() {
    let store = "https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726"
    if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
```

<br/>

### 이용방법
설정의 '이용방법' 버튼을 클릭하면 앱을 처음 설치하고 접속했을 때 보여줬던 **튜토리얼을 다시 볼 수 있다.** 처음에 튜토리얼을 스킵 해서 어떻게 앱을 사용해야 할지 모르는 사용자를 위해서 구현했다.

<br/>

<p align="center"><img alt="이용방법" src="https://user-images.githubusercontent.com/49383370/156299103-04fa8d6c-a319-46e2-887e-d0bc5d20924d.png" width="200"></p>

<br/>

### 로그아웃
사용자가 익명인 경우에는 로그아웃 후 다시 익명으로 로그인하게 되면 이전과 다른 아이디로 가입되기 때문에 사용자가 익명인 경우를 다뤄줘야 한다. 

그래서 우선 **FirebaseAuth**의 **isAnonymous**으로 현재 사용자가 익명인지 확인한다. 익명이라면 **User/(사용자 uid)** 경로에 있는 데이터를 삭제하고 로그인 화면으로 이동한다.

익명이 아니라면 로그아웃 처리만 하고 로그인 화면으로 이동한다. 다시 앱에 접속하면 이전에 로그아웃 처리되었기 때문에 로그인화면이 보여진다.

<br/>

file: SettingViewModel
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid = Auth.auth().currentUser?.uid

/// 로그아웃 Alert 창
func logoutAlert(_ viewController: SettingViewController) -> UIAlertController {
    let isAnonymous = Auth.auth().currentUser?.isAnonymous
    let alertController = UIAlertController(
        title: "로그아웃",
        message: "정말 로그아웃하시겠습니까?",
        preferredStyle: UIAlertController.Style.actionSheet
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

    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    return alertController
}

/// 익명 사용자 로그아웃
func anonymousLogout(_ viewController: SettingViewController) {
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
func generalLogout(_ viewController: SettingViewController) {
    do {
        try Auth.auth().signOut()
        viewController.navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
        print("ERROR: signout \(signOutError.localizedDescription)")
    }
}
```

<br/>

### 앱 버전 가져오기
설정화면에 현재 앱의 버전과 앱스토어에 출시된 최신 버전을 표시하도록 구현했다. 현재 버전은 infoDictionary에 키값으로 접근하여 가져왔고, 최신 버전은 '모닥이' 앱의 번들 아이디를 포함한 URL을 통해 앱스토어에 출시된 '모닥이'의 정보를 JSON 형식으로 읽어온 후 가져왔다.

<br/>

file: SettingViewModel
```swift
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
```

<br/>

<!-- 10. Design -->
## Design
### Point Color
The color is reminiscent of the bonfire, the symbol of Modakyi.
<p align="left"><img alt="color" width="100" src="https://user-images.githubusercontent.com/49383370/155312772-f11a795b-02f3-41b7-a48c-8bf855998449.png"></p>

### App Icon
To express the bonfire, it is composed of a fire image with a point color.
<p align="left"><img alt="icon" width="100" src="https://user-images.githubusercontent.com/49383370/155313186-0e16889a-f425-4434-a019-8c734ef2ec19.png"></p>

### UI/UX
<p align="center"><img alt="UI" src="https://user-images.githubusercontent.com/49383370/158762919-2e181fb7-4874-477c-9f2a-86107146ae7a.png"></p>

<br/>

<!-- 11. First Time -->
## First Time
### 1. Firebase(Realtime Database, FCM, Authentication)
여태까지 UserDefaults를 활용해 기기 로컬에 데이터를 저장했는데, 이번에는 클라우드 서비스인 Firebase의 Realtime Database에 데이터가 저장되도록 구현했다. 그리고 FCM(Firebase Cloud Messaging)으로 매일 새로운 글귀 업로드 알림을 사용자 기기로 보낸다. 또, 인증 서비스를 이용해서 이메일 로그인, 소셜(구글, 애플) 로그인, 익명 로그인도 구현했다.

<br/>

### 2. AdMob 전면광고
'Scoit' 개발 때 다뤄본 AdMob 배너 광고를 이번에도 넣었지만 수입이 생각보다 적어서 전면광고도 추가했다. 글귀를 클릭하면 나타나는 상세 화면이 dismiss될 때마다 전면 광고를 띄우도록 했다. 엄청 복잡할 줄 알았는데, 생각보다 간단하다. 전면 광고 객체를 변수로 만들고 객체의 루트 뷰를 현재 화면으로 설정해서 띄워주면 된다.

<br/>

### 3. 버전 정보 가져오기
설정 화면에 앱의 현재 버전과 앱 스토어에 출시된 최신 버전을 표시하고 싶어서 이번에 처음 다뤄보았다. 실제 꽤 많은 앱의 설정에 사용되기 때문에 매우 유용한 기능이라 생각한다.

> 내용 정리: https://velog.io/@minji0801/iOS-현재-버전-최신-버전-확인하는-방법

<br/>

### 4. 공유하기 기능
글귀를 텍스트 또는 이미지로 공유하기 위해서 UIActivityViewController를 처음 사용해 봤다. 이 뷰를 PopOver 형식으로 띄우기 위해서는 위치를 정해줘야 했다. 위치를 정해주지 않아 iPad에서 에러가 발생하는 이 문제 때문에 리젝됬었지만 해결했다.

> 내용 정리: https://velog.io/@minji0801/iOS-Swift-텍스트-또는-이미지-공유하기

<br/>

### 5. MessageUI
Mail 앱을 이용해서 개발자에게 피드백을 보내기 위해서 MessageUI를 처음 다뤄보았다. 시뮬레이터에서는 Mail 앱이 실행되지 않기 때문에 실기기로 테스트했다. 그리고 메일 전송을 실패했을 때 Alert 창을 띄우고 사용자가 Mail 앱을 설치하거나 이메일 설정을 확인하도록 유도했다.

> 내용 정리: https://velog.io/@minji0801/iOS-Swift-iOS-기기에서-Mail-앱-이용해서-이메일-보내는-방법

<br/>

### 6. MVVM 리팩토링
기존 MVC 구조에서 MVVM 구조로 리팩토링을 진행했다. 리팩토링하는 중에 이 부분은 ViewController에 둬야할지 ViewModel에 둬야할지 헷갈린 부분이 많았지만, ViewController이 직접 Model과 연결될 수 없고 ViewModel을 통해서 연결됨을 계속 생각했고 최대한 ViewController이 가지고 있던 일들을 ViewModel에게 나누어주도록 리팩토링했다.

<br/>

<!-- 12. Meet -->
## Meet
### App Store
> https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726

### Notion
> https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7

### Gmail
> modakyi.help@gmail.com

<br/>

<!-- 13. History -->
## History
### v1.0.0 (2021.11.25)
> - Provides basic functions
> - Reject once (Reason: No anonymous login)

### v1.0.1 (2021.11.26)
> - Fix logout error (write clearer code to proceed with logout when not an anonymous user)

### v1.0.2 (2021.12.3)
> - Add email login loading step
> - Delete app update notification (Siren)

### v1.1.0 (2021.12.5)
> - Add banner ad at the bottom of the text
> - Fix getting the latest version

### v1.2.0 (2021.12.13)
> - Add text sharing
> - Reject 1 time (Reason: Shared screen marked with Popover is not visible on iPad)

### v1.3.0 (2022.1.13)
> - Add app tracking permission
> - Add interstitial ads

### v1.4.0 (2022.2.6)
> - Add app rating
> - Settings screen UI, text sharing icon change
> - Edit tutorial screen
> - Add pull-to-refresh to Favorite Phrases, Unused Phrases, and Phrases Search

### v1.4.1 (2022.3.2)
> - Add loading step to Apple login, anonymous login
> - UI change (icons and colors, etc.)
> - Fix dark mode error
> - Freeze iPad screen (no rotation)
> - Architecture change (MVVM)

### v1.5.0 (2022.3.17)
> - Settings screen change (TableView)
> - Add themes and fonts
> - Correct the time of the latest text (2 days)
> - Correction of errors in inquiries and comments

<br/>
<br/>

---

<br/>
<br/>
<br/>

<!-- Footer -->
<div align="center">
  <a href="https://github.com/minji0801"><img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=codeSTACKr"/></a>
  
  <br/>
  <br/>
  <br/>
  
  <a href="https://github.com/minji0801/Modakyi"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FModakyi&count_bg=%23E76140&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
</div>

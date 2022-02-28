<div align="center">
  
  <!-- Header -->
  ![header](https://capsule-render.vercel.app/api?type=waving&color=E76140&height=300&section=header&text=모닥이&desc=글귀%20%2F%20명언%20모음%20앱&descAlignY=60&fontSize=85&fontAlignY=40&fontColor=FFFFFF)
  
  <br/>
  <br/>
  
  <!-- Badge -->
  ![version](https://img.shields.io/badge/v-1.4.0-brightgreen?style=flat-square)
  
  <br/>
  <br/>
  
  ![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
  ![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=Firebase&logoColor=black)
  ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white)
  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)
  [![App Store](https://img.shields.io/badge/App%20Store-0D96F6?style=flat-square&logo=App%20Store&logoColor=white)](https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726)
  [![Notion](https://img.shields.io/badge/Notion-181717?style=flat-square&logo=Notion&logoColor=white)](https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7)
  [![Gmail](https://img.shields.io/badge/Gmail-EA4335?style=flat-square&logo=Gmail&logoColor=white)](https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=modakyi.help@gmail.com)

  <br/>
  <br/>
  <br/>

  #### 모닥불 앞에 있으면 몸이 따뜻해지듯이,

  #### 모닥이가 당신의 마음을 따뜻하게 어루만져 주길.
</div>

<br/>
<br/>
<br/>

<!-- Navigation -->
# 목차
1. [개발 동기](#-개발-동기)
2. [개발 목표](#-개발-목표)
3. [로그인](#-로그인)
4. [글귀 관리](#-글귀-관리)
5. [추천 글귀와 전체 글귀](#-추천-글귀와-전체-글귀)
6. [글귀 상세 보기](#-글귀-상세-보기)
7. [좋아하는 글귀와 미사용 글귀](#-좋아하는-글귀와-미사용-글귀)
8. [글귀 검색](#-글귀-검색)
9. [설정](#-설정)
10. [화면 및 디자인](#-화면-및-디자인)
11. [이번에 처음 다룬 것](#-이번에-처음-다룬-것)
12. [만나러 가기](#-만나러-가기)
13. [버전 기록](#-버전-기록)

<br/>

<!-- 1. 개발 동기 -->
## 🔥 개발 동기
- **매번 공부 자극 글귀를 찾아보기 귀찮다.**
  - 매일 플래너에 공부 자극 글귀나 명언을 작성하는 데에 불편함이 있다.
  - SNS에 저장해 둔 공부 자극 글귀를 매번 찾아서 확인해야 한다.

- **공부 자극 글귀의 사용 여부를 기억하기 힘들다.**
  - 해당 공부 자극 글귀를 사용한 적 있는지 의문이 들 때가 종종 있다.
  - 글귀 사용 여부를 체크할 수 있다면 편리할 것이다.

<br/>

<!-- 2. 개발 목표 -->
## 🎯 개발 목표
- **글귀 확인**
  - 공부 자극 글귀나 명언들을 한 화면에서 편리하게 확인할 수 있다.
  - 특정 모음으로 모아서 한곳에서 볼 수 있도록 한다.

- **사용 여부 표시**
  - 사용자가 글귀를 사용했는지의 여부를 표시한다.
  - 사용하지 않은 순으로 정렬하거나 따로 모아볼 수 있도록 한다.

- **좋아하는 글귀 표시**
  - 사용자가 글귀에 좋아요를 표시하고 따로 모아서 확인할 수 있다.

- **글귀 추천**
  - 사용자가 앱에 접속할 때마다 랜덤한 글귀를 추천하는 공간을 제공한다.

<br/>

<!-- 3. 로그인 -->
## 📲 로그인
앱에 접속했을 때 처음 접하는 화면이 로그인 화면이다. 현재 사용자가 있는지를 체크하고 없으면 그대로 로그인 화면을 보여주고, 현재 사용자가 있으면 메인 화면으로 이동한다. 로그인은 총 4종류로 모두 FirebaseAuth를 이용해서 구현했다.

<br/>

<p align="center"><img alt="로그인화면" src="https://user-images.githubusercontent.com/49383370/155922369-1a86a543-4010-4552-811f-bd580be05f0d.PNG" width="200"></p>

<br/>

### 1. 이메일 로그인
FirebaseAuth의 **createUser** 메서드를 이용해서 사용자로부터 입력받은 이메일과 비밀번호로 **새로운 유저정보를 생성**한다. 이미 가입한 계정이라면 **signIn** 메서드로 **로그인을 진행**한다.

<br/>

file: EnterEmailViewModel
```swift
import FirebaseAuth

/// 신규 사용자 생성
func createUser(_ email: String, _ password: String, completion: @escaping (String, Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
        if let error = error {
            let code = (error as NSError).code
            switch code {
            case 17007: // 이미 가입한 계정일 때 로그인하기
                completion("signin", error)
            default:
                completion("error", error)
            }
        } else {
            completion("signup", error)
        }
    }
}

/// 이메일 로그인
func loginUser(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { _, error in
        if let error = error {
            completion(false, error)
        } else {
            completion(true, error)
        }
    }
}
```

<br/>

### 2. 구글 로그인
**GoogleSignIn**을 이용해서 구글 로그인을 구현했다. 구글 로그인 인증이 완료되면 **FirebaseAuth**의 **signIn** 메서드로 로그인을 진행한다. 처음 가입한 사용자의 경우 닉네임과 프로필 이미지를 데이터베이스에 저장하기 위해서  **setValueCurrentUser** 사용자 정의 함수를 호출한 후 메인화면으로 이동한다. 

<br/>

file: LoginViewController
```swift
import GoogleSignIn

/// 구글 로그인 버튼 클릭
@IBAction func googleLoginButtonTapped(_ sender: UIButton) {
    GIDSignIn.sharedInstance().signIn()
}
```

<br/>

file: AppDelegate
```swift
import GoogleSignIn

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    // Google 로그인 인증 후 전달된 값을 처리하는 부분
    if let error = error {
        print("ERROR Google Sign In \(error.localizedDescription)")
        return
    }

    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(
        withIDToken: authentication.idToken,
        accessToken: authentication.accessToken
    )

    Auth.auth().signIn(with: credential) { _, _ in
        // Google Login User 데이터 만들기
        setValueCurrentUser()
        showMainVCOnRoot()
    }
}
```


<br/>

### 3. 애플 로그인
애플 계정을 이용한 로그인에는 **AuthenticationServices**와 **CryptoKit** 프레임워크를 사용했다. 애플 로그인 시 이메일을 가릴지 보여줄 지 선택할 수 있는 부분이 있다. 이메일을 가리면 랜덤한 이메일이 부여가되는데, CryptoKit으로 안전하게 암호화된 랜덤한 난수를 만든다.

<br/>

file: LoginViewModel
```swift    
import AuthenticationServices
import CryptoKit

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
```

<br/>

그리고 LoginViewController에 상속되어 있는 **ASAuthorizationControllerDelegate**에서 아이디 토큰과 난수를 가지고 **credential**을 만든다. 이 credential 값으로 FirebaseAuth의 **signIn** 메서드를 통해 로그인한다.

<br/>

file: LoginViewController
```swift
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
```

<br/>

### 4. 익명 로그인
익명 로그인은 처음에 구현하지 않았는데, 로그인이 필요한 앱은 **로그인 없이도 사용할 수 있어야한다**는 애플의 지침에 맞추기 위해서 추가했다. **FirebaseAuth**에서 익명 로그인을 지원한다. 다만, **로그아웃하면 데이터가 삭제**되기 때문에 관련 로그아웃 Alert 창을 띄우도록 구현했다.

<br/>

Alert 창에서 '네'를 선택하면 FirebaseAuth의 **signInAnonymously** 메서드로 익명 로그인을 진행한다. 

<br/>

file: LoginViewModel
```swift
import FirebaseAuth

/// 익명 로그인 Alert 창
func anonymousLoginAlert(
    _ viewController: LoginViewController,
    completion: @escaping () -> Void
) -> UIAlertController {
    let alertController = UIAlertController(
        title: "로그인 건너뛰기",
        message: "로그아웃 또는 앱 삭제 시 데이터가 삭제될 수 있습니다. 진행하시겠습니까?",
        preferredStyle: .actionSheet
    )

    let confirmAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
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

    let cancelAction = UIAlertAction(title: "아니요", style: .destructive, handler: nil)

    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    return alertController
}
```

<br/>

<!-- 4. 글귀 관리 -->
## 📝 글귀 관리
글귀는 StudyStimulateText 구조체 형태로 저장되어 사용된다.

<br/>

file: StudyStimulateText
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

실제로 Firebase RealtimeDatabase에 아래와 같은 모습으로 글귀가 저장된다. (Text+글귀 아이디)를 해당 데이터의 고유 아이디로 사용한다. 새로운 글귀는 매일 1개씩 데이터베이스에 추가하여 관리하고 있다.

<br/>

<p align="center"><img alt="데이터" src="https://user-images.githubusercontent.com/49383370/155842262-955d605e-67d1-4357-8c71-5fbb3aaf8d47.png" width="400"></p>

<br/>

<!-- 5. 추천 글귀와 전체 글귀 -->
## 🏠 추천 글귀와 전체 글귀
모닥이의 홈 화면에서 추천 글귀와 전체 글귀를 보여준다.

<br/>

<p align="center"><img alt="홈" src="https://user-images.githubusercontent.com/49383370/155922506-7bb4cb9d-7f3d-4f3f-b803-1f5ac0b42448.jpeg" width="200"></p>

<br/>

Firebase **RealitimeDatabase의 Text 경로**로 접근하여 전체 글귀를 가져오고, 전체 글귀에서 **랜덤한 값을 추천 글귀 아이디로** 가져온다. 그리고 업로드 시간부터 금일까지 하루가 안지났으면 **새로운 글귀**로 분류하여 가져온다.

<br/>

file: HomeViewModel
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid: String? = Auth.auth().currentUser?.uid

lazy var fullText: [StudyStimulateText] = [] // 전체 글귀
lazy var recommendedTextId = ""             // 추천 글귀 id
lazy var newTextIDs: [String] = []          // 새 글귀 id

/// 전체 글귀, 추천 글귀 아이디, 새로운 글귀 아이디 가져오기
func getFullText(completion: @escaping () -> Void) {
    ref.child("Text").observe(.value) { [weak self] snapshot in
        guard let self = self,
              let value = snapshot.value as? [String: [String: String]] else { return }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value)
            let textData = try JSONDecoder().decode([String: StudyStimulateText].self, from: jsonData)
            let texts = Array(textData.values)

            self.fullText = texts.sorted { Int($0.id)! > Int($1.id)! }
            self.recommendedTextId = self.fullText.randomElement()!.id
            self.newTextIDs = self.fullText.filter { self.timeDifference(uploadTime: $0.time) }.map { $0.id }
            completion()

        } catch let error {
            print("ERROR JSON Parsing \(error.localizedDescription)")
        }
    }
}
```

<br/>

새로운 글귀의 셀에 **빨간 점**을 표시할건데, 만약 사용자가 **이미 클릭한적이 있다면 빨간 점을 보여주지 않을 것**이다. 그래서 **User의 clicked 경로**로 접근하여 현재 사용자가 클릭한 글귀의 아이디를 가져온다.

<br/>

file: HomeViewModel
```swift
import FirebaseAuth
import FirebaseDatabase

private let ref: DatabaseReference! = Database.database().reference()
private let uid: String? = Auth.auth().currentUser?.uid

lazy var clickedTextIDs: [String] = []      // 클릭한 글귀 id
    
/// 사용자가 클릭한 글귀 아이디 가져오기
func getClickedTextId() {
    ref.child("User/\(uid!)/clicked").observe(.value) { [weak self] snapshot in
        guard let self = self else { return }

        if let value = snapshot.value as? [String] {
            self.clickedTextIDs = value
        }
    }
}
```

<br/>

<!-- 6. 글귀 상세 보기 -->
## 👀 글귀 상세 보기
글귀를 클릭하면 내용을 크게 볼 수 있다. 그리고 해당 글귀의 좋아요, 사용 여부를 체크할 수 있고 텍스트나 이미지로 공유할 수 있다.

<br/>

<p align="center"><img alt="상세" src="https://user-images.githubusercontent.com/49383370/155937567-42aa6f01-e430-42e3-9656-4651b9cd9d83.PNG" width="200"></p>

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

<p align="center"><img alt="좋아요" src="https://user-images.githubusercontent.com/49383370/155926177-8e6ae429-b83e-4c78-bb53-71d0a888a7d5.PNG" width="200"></p>

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

<p align="center"><img alt="미사용" src="https://user-images.githubusercontent.com/49383370/155926414-34299529-37e9-433c-a457-3016087a8a0d.jpeg" width="200"></p>

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

<p align="center"><img alt="검색" src="https://user-images.githubusercontent.com/49383370/155936704-d986c836-5fe7-4141-8570-685d9cf8ad06.PNG" width="200"></p>

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

<p align="center"><img alt="설정" src="https://user-images.githubusercontent.com/49383370/155937645-18f23a93-603d-47ed-8375-15108b96155a.jpeg" width="200"></p>

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
    if viewController.overrideUserInterfaceStyle == .light {
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

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155937711-0e0b53ec-44d7-4e99-8d78-933e70ad6163.PNG" width="200"></p>

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

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155327206-a27fa9e1-d877-460c-b3ba-03df8308386b.jpeg" width="200"></p>

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

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155937978-4ce096ed-ef24-4021-b3fb-9268c0373e5f.jpeg" width="200"></p>

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

<!-- 10. 화면 및 디자인 -->
## 🌈 화면 및 디자인
### Point Color

모닥이의 상징인 모닥불이 연상되는 '다홍색'을 포인트 색상으로 넣었다.

<br/>

<p align="left"><img src="https://user-images.githubusercontent.com/49383370/155312772-f11a795b-02f3-41b7-a48c-8bf855998449.png"></p>

<br/>

### App Icon

아이콘 이미지도 모닥불을 표현하기 위해서 포인트 색상으로 불 이미지로 구성했다. 모닥이를 통해서 모두의 마음이 따뜻해지길 바람을 표현한 것이다.

<br/>

<p align="left"><img src="https://user-images.githubusercontent.com/49383370/155313186-0e16889a-f425-4434-a019-8c734ef2ec19.png" width="100"></p>

<br/>

### UI/UX

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155940280-8fb79ea2-1f7d-41cd-b38f-5a5b3fe49bfe.png"></p>

<br/>

<!-- 11. 이번에 처음 다룬 것 -->
## 🐥 이번에 처음 다룬 것
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

<!-- 12. 만나러 가기 -->
## 👀 만나러 가기
### App Store
> https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726

### Notion
> https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7

### Gmail
> modakyi.help@gmail.com

<br/>

<!-- 13. 버전 기록 -->
## 🚀 버전 기록
### v1.0.0 (2021. 11. 25)
> - 기본 기능 제공 (추천・전체 글귀 확인, 좋아하는 글귀・사용한 글귀 표시, 글귀 검색 등)
> - 한 번 거절 (사유: 익명 로그인 불포함)

### v1.0.1 (2021. 11. 26)
> - 로그아웃 오류 수정(익명 유저가 아닐 때 로그아웃을 진행하도록 더 명확한 코드 작성)

### v1.0.2 (2021. 12. 3)
> - 이메일 로그인 로딩(Indicator) 추가
> - 앱 업데이트 알림(Siren) 기능 삭제

### v1.1.0 (2021. 12. 5)
> - 글귀 하단 배너 광고 추가
> - 앱 최신 버전 가져오기 수정

### v1.2.0 (2021. 12. 13)
> - 글귀 공유하기 기능 추가
> - 한 번 거절 (사유: Popover로 띄워지는 공유하기 화면이 iPad에서 보이지 않음) 

### v1.3.0 (2022.1.13)
> - 앱 추적 권한 추가
> - 전면 광고 추가

### v1.4.0 (2022.2.6)
> - 앱 평가 기능 추가
> - 설정 화면 UI, 글귀 공유 아이콘 변경
> - 튜토리얼 화면 수정
> - 좋아하는 글귀 모음, 미사용 글귀 모음, 글귀 검색에 당겨서 새로고침 추가

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

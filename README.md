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
5. [좋아하는 글귀와 미사용 글귀](#-좋아하는-글귀와-미사용-글귀)
6. [글귀 검색](#-글귀-검색)
7. [설정](#-설정)
8. [화면 및 디자인](#-화면-및-디자인)
9. [이번에 처음 다룬 것](#-이번에-처음-다룬-것)
10. [만나러 가기](#-만나러-가기)
11. [버전 기록](#-버전-기록)

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

<!-- 3. 시간 계산 -->
## ⏰ 시간 계산

### 1. 시간 형식 변환

시간 계산에서 제일 큰 문제는 **"연산자를 클릭할 때 입력한 시간 또는 연산 결과를 올바른 시간 포맷으로 보여줘야 한다"** 는 것이다.

> 예시) 
>
>     입력: 3:66 +
>     출력: 4:06
> 
>     입력: 1:50 + 0:25
>     출력: 2:15

<br/>
<br/>

그래서 입력 값을 올바른 시간 형식으로 변환하는 메서드를 만들었다. 입력한 시간의 분이 60~99 사이라면 분에 60을 빼고 시에 1을 더한다.

연산 기호를 누른 후 반드시 실행되며, 연산 결과가 있다면 그 결과값에도 적용된다.

> 예시) 
>
>     입력: 3:66 +
>     convertTimeFormat 메서드가 호출된다.
>     [String] 타입으로 입력한 시간을 파라미터로 받아온다. ➜ (["3", "6", "6"])
>     분(66)이 60~99 사이니까 분에 60을 빼고 시에 1을 더한 값인 406을 반환한다.

<br/>

```swift
// 시간 형식으로 맞춰 변환하는 함수
func convertTimeFormat(_ value: [String]) -> String {
    // 시간 포맷에 맞추기 (분이 60에서 99사이라면 60을 뺀 값을 분에 적고 시에 +1 해주기)
    // 두글자 이상일 때 [6, 1] 뒤에서 두글자 가져오기
    if value.count > 1 {
        let lastIndex = value.lastIndex(of: value.last!)!
        var operandMinute = Int(value[lastIndex - 1 ... lastIndex].joined())!

        if operandMinute > 59 {
            var operandHour = 0

            if value.count > 2 {
                operandHour = Int(value[0...lastIndex - 2].joined())!
            }
            operandHour += 1
            operandMinute -= 60
//                print("format => \(operandHour):\(String(format: "%02d", operandMinute))")
            return "\(operandHour)\(String(format: "%02d", operandMinute))"
        }
    }
    return value.joined()
}
```

<br/>
<br/>

### 2. 뺄셈과 덧셈

우선, 뺄셈은 첫번째 피연산자가 세자리 이상이고 분이 두번째 피연산자의 분보다 작으면 40을 뺀다.
> 예시) 
>
>     입력: 1:05 - 0:30 =
>     계산: 105 - 30 - 40 = 35
>     출력: 0:35
>
> ➜ 첫번째 피연산자(105)가 세자리이고, 분(5)이 두번째 피연산자의 분(30)보다 작기 때문에 40을 뺐다.

<br/>

그리고 덧셈에서는 아래와 같이 계산되는 문제가 있었다. 입력한 시간을 String에서 Int형으로 바꾸고 더했으니 그 결과가 출력된 것이다.
> 예시)
>
>     입력: 0:58 + 0:53 = 
>     출력: 1:11 (원래 1:51)

<br/>

그래서 덧셈은 입력한 시간의 분이 모두 두자리이고 분의 합이 100을 넘으면 40을 더한다.
> 예시)
>
>     입력: 0:58 + 0:53 =
>     계산: 58 + 53 + 40 = 151 
>     출력: 1:51 
>
> ➜ 입력한 시간의 분(58과 53)이 모두 두자리고, 두 합(111)이 100을 넘기때문에 40을 더했다.

<br/>
<br/>

### 3. 연산자 연속 클릭 시
처음에는 연산자 버튼을 클릭하면 해당 연산을 바로 실행하도록 구현했는데, 그러면 연산자 버튼을 연속으로 클릭했을 때가 문제다. 그래서 operation 메서드를 만들어서 연산자 버튼이 클릭될 때마다 호출한다.

> operation 메서드 
>
>     displayNumber 변수에 값이 있을 때만 연산을 수행한다.
>     (displayNumber는 입력한 시간을 숫자형태로 저장하는 String 타입 변수)
>     (즉, 2:58을 입력하면 displayNumber는 "258"이다.)
>     따라서, 연산자 버튼을 연속해서 클릭하더라도 에러가 발생하지 않는다.

<br/>

```swift
// 연산 함수
func operation(_ operation: Operation) {
    self.isClickedOperation = true
    self.displayNumber = convertTimeFormat(displayNumber.map { String($0) })

    if self.currentOperation != .unknown {
        // 두번째 이상으로 연산기호 눌렀을 때
        if !self.displayNumber.isEmpty {
            self.secondOperand = self.displayNumber
            self.displayNumber = ""

            guard let firstOperand = Int(self.firstOperand) else { return }
            guard let secondOperand = Int(self.secondOperand) else { return }

            // 연산 실시
            switch self.currentOperation {
            case .add:
                // 둘다 분이 두자리고 두 합이 100이 넘으면 40 더하기
                let firstMin = self.firstOperand.suffix(2)
                let secondMin = self.secondOperand.suffix(2)

                if firstMin.count == 2 && secondMin.count == 2 && (Int(firstMin)! + Int(secondMin)!) > 99 {
                    self.result = "\(firstOperand + secondOperand + 40)"
                } else {
                    self.result = "\(firstOperand + secondOperand)"
                }

            case .subtract:
                self.result = String(minusOperation(self.firstOperand, self.secondOperand))

            default:
                break
            }

            self.result = convertTimeFormat(self.result.map { String($0) })
            self.firstOperand = self.result
            self.outputLabel.text = updateLabel(self.result)
        }

        self.currentOperation = operation
    } else {
        // 처음으로 연산기호 눌렀을 때
        self.outputLabel.text = updateLabel(self.displayNumber)
        self.firstOperand = self.displayNumber
        self.currentOperation = operation
        self.displayNumber = ""
    }
}
```

<br/>

<!-- 4. 디데이 계산 -->
## 📅 디데이 계산

디데이 계산이 은근 헷갈렸다. Calendar의 dateComponents메서드로 기준일과 종료일의 차이를 계산한다. 계산 결과가 음수면 절대값으로 변환하고 앞에 "+"를 붙이고, 계산 결과가 0이거나 양수면 1을 더한 후 앞에 "-"를 붙인다.

> 예시)
>
>     기준일: 2022.2.10, 종료일: 2022.2.17
>     dateComponents 메서드의 결과가 6이라서 1을 더하고 앞에 "-"를 붙인다.
>     출력: D - 7
>
>     기준일: 2022.2.10, 종료일: 2022.2.3
>     dateComponents 메서드의 결과가 -7이라서 절대값으로 변환한 후 앞에 "+"를 붙인다.
>     출력: D + 7

<br/>

```swift
// 디데이 계산
func calculationDday() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let language = UserDefaults.standard.array(forKey: "Language")?.first as? String {
        formatter.locale = Locale(identifier: language)
    }

    let startDate = formatter.string(from: startDatePicker.date)
    let endDate = formatter.string(from: endDatePicker.date)

//        print("startDate : \(startDate), endDate : \(endDate)")

    if startDate == endDate {
        return "- DAY"
    } else {
        let result = Calendar.current.dateComponents(
            [.day],
            from: startDatePicker.date,
            to: endDatePicker.date
        ).day!
//            print("result = \(result)")
        if result < 0 {
            // result가 음수면 절대값씌워서 앞에 + 붙이기
            return "+ \(result.magnitude)"
        } else {
            // 0이거나 양수면 1더해서 앞에 - 붙이기
            return "- \((result + 1))"
        }
    }
}
```
<br/>

<!-- 5. 계산 기록 -->
## 📝 계산 기록
등호(=) 버튼을 클릭했을 때 UserDefaults를 이용해서 계산식을 로컬에 저장한다.

```swift
// = 버튼 눌렀을 때
@IBAction func equalButtonTapped(_ sender: UIButton) {
    symbolLabel.text = ""
    self.operation(self.currentOperation)
    self.isClickedEqual = true
    self.isClickedOperation = false

    // 계산 기록하기 : 계산식이 담긴 문자열(연산식 + "=" + 결과값)을 UserDefaults에 저장하기
    // formula가 "0:00 = 0:00"이면 저장하지 않기
    // ex) 4:16 + 1:09 + 0:37 = 6:02

    self.formula += "\(updateLabel(self.secondOperand)) = \(self.outputLabel.text!)"

    if self.formula != "0:00 = 0:00" {
        var history = UserDefaults.standard.array(forKey: "History") as? [String]
        if history == nil {
            history = [formula]
        } else {
            history?.append(formula)
        }
        UserDefaults.standard.set(history!, forKey: "History")
    }
    self.formula = ""
}
```

<br/>

단, 올바른 계산식을 만들기 위해서 숫자 버튼을 클릭할 때마다 isClickedOperation 변수를 확인한다. 

<br/>

숫자 버튼을 눌렀을 때 이미 더하기(+)나 빼기(-)를 누른적이 있다면(isClickedOperation = true) 계산식을 만들고, 더하기(+)나 빼기(-)를 누른적은 없지만 등호(=)를 누른적이 있다면(isClickedOperation = false, isClickedEqual = true) 피연산자와 현재 연산자의 값을 초기화한다.

<br/>

계산식을 만들기 위해 첫번째 피연산자를 가져올 때 주의해야 한다. 즉, 연산을 제일 처음하는 경우를 말하는데, 두번째 피연산자가 없을 때와 등호(=)를 누른 후 추가 연산을 할 때만 첫번째 피연산자를 가져온다.

<br/>

그리고 여기서 두번째 피연산자가 반복해서 계산식에 입력되는 문제가 있었다. 그래서 isAddedFormula 변수로 두번째 피연산자를 계산식에 넣었는지 확인한다. 더하기(+)나 빼기(-) 를 클릭하면 false로 값을 초기화한다.

```swift
// 올바른 계산식 만들기
func createCorrectFormula() {
    if self.isClickedOperation {    // +나 -연산자 누른적 있으면
        // 첫번째 연산자 가져오는 경우 : 두번째 연산자가 없을 때, = 기호 누른 후 추가로 연산할 때
        if self.secondOperand.isEmpty || isClickedEqual {
            formula = updateLabel(self.firstOperand)
            switch self.currentOperation {
            case .add:
                formula += " + "
            case .subtract:
                formula += " - "
            default:
                break
            }
        } else {
            // secondOperand를 이미 formula에 넣은 경우는 다시 넣지 않도록
            if !self.isAddedFormula {
                formula += updateLabel(self.secondOperand)
                switch self.currentOperation {
                case .add:
                    formula += " + "
                case .subtract:
                    formula += " - "
                default:
                    break
                }
                self.isAddedFormula = true
            }
        }
    } else {    // +나 -연산자 누른적은 없지만 =연산자 누른적 있으면
        if self.isClickedEqual {
            self.firstOperand = ""
            self.secondOperand = ""
            self.currentOperation = .unknown
            self.isClickedEqual = false
        }
    }
}
```

<br/>

<!-- 6. 설정 -->
## 🛠 설정
### 사용자 정보 가져오기
모닥이의 설정화면에서는 현재 로그인한 유저의 프로필 이미지와 닉네임을 확인할 수 있다. FirebaseAuth를 이용해서 현재 로그인한 사용자의 정보를 가져와 UI Component에 뿌려준다.

<br/>

```swift
import FirebaseAuth

// Profile Image / UserName
let username = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "User"
let profileImg = Auth.auth().currentUser?.photoURL ?? URL(string: "")

nameLabel.text = username
profileImage.kf.setImage(with: profileImg, placeholder: UIImage(systemName: "person.crop.circle"))
profileImage.layer.cornerRadius = profileImage.bounds.width / 2
```

<br/>

### 알림 설정
알림 설정의 경우 원래 다른 앱과 비슷하게 스위치 버튼을 통해 켜고 끄고가 가능하도록 구현하는 게 목표였다. 하지만 앱 내에서 설정의 값을 변경시키는 게 적용되지 않았고, 우선 설정화면으로 이동하는 것으로 구현했다. 

<br/>

```swift
// 알림설정
@IBAction func notificationSettingButtonTapped(_ sender: UIButton) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
```

<br/>

### 다크 모드
UserDefaults를 이용해서 키가 "Appearance"인 곳에 테마 모드를 저장시켜놓고, ViewController의 viewWillAppear에서 호출되는 appearanceCheck() 함수를 통해서 현재 앱에 설정되어 있는 모드를 적용시키도록 구현했다.

<br/>

```swift
// (1) 테마 설정
@IBAction func darckModeButtonTapped(_ sender: UIButton) {
    if self.overrideUserInterfaceStyle == .light {
        UserDefaults.standard.set("Dark", forKey: "Appearance")
    } else {
        UserDefaults.standard.set("Light", forKey: "Appearance")
    }
    self.viewWillAppear(true)
}

// (2) view가 보여질 때마다 테마 적용
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appearanceCheck(self)
}

// (3)UserDefaults에 저장된 값을 통해 테마 확인
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

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155324844-e65e89cb-715b-4d26-b59c-df71fa009a67.PNG" width="200"></p>

<br/>

### 문의 및 의견
MessageUI 프레임워크를 이용하여 Mail 앱을 통해 이메일을 작성하는 화면을 보여주고, 메일을 작성하여 개발자에게 보낼 수 있다. 메일 보내기에 실패한 경우 Alert 창을 띄워 사용자가 Mail 앱을 설치하거나 이메일 설정을 확인할 수 있도록 구현했다.

<br/>

```swift
import MessageUI

// 문의 및 의견
@IBAction func commentsButtonTapped(_ sender: UIButton) {
    if MFMailComposeViewController.canSendMail() {
        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self

        let bodyString = """
                         이곳에 내용을 작성해주세요.

                         오타 발견 문의 시 아래 양식에 맞춰 작성해주세요.

                         <예시>
                         글귀 ID : 글귀 4 (글귀 클릭 시 상단에 표시)
                         수정 전 : 실수해도 되.
                         수정 후 : 실수해도 돼.

                         -------------------

                         Device Model : \(self.getDeviceIdentifier())
                         Device OS : \(UIDevice.current.systemVersion)
                         App Version : \(self.getCurrentVersion())

                         -------------------
                         """

        composeViewController.setToRecipients(["modakyi.help@gmail.com"])
        composeViewController.setSubject("<모닥이> 문의 및 의견")
        composeViewController.setMessageBody(bodyString, isHTML: false)

        self.present(composeViewController, animated: true, completion: nil)
    } else {
        self.alertFailureSendMail()
    }
}

// 메일 보내기 실패 Alert 띄우기
func alertFailureSendMail() {
    let sendMailErrorAlert = UIAlertController(
        title: "메일 전송 실패",
        message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
        preferredStyle: .alert
    )
    
    let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { [weak self] _ in
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
    self.present(sendMailErrorAlert, animated: true, completion: nil)
}

// MARK: - MailComposeViewController Delegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    // (피드백 보내기) 메일 보낸 후
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        self.dismiss(animated: true, completion: nil)
    }
}
```

<br/>

### 앱 평가
'앱 평가' 버튼을 클릭하면 App Store 모닥이 앱 페이지로 이동하여 사용자가 앱을 평가할 수 있도록 구현했다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155327206-a27fa9e1-d877-460c-b3ba-03df8308386b.jpeg" width="200"></p>

<br/>

```swift
// 앱 평가
@IBAction func reviewButtonTapped(_ sender: Any) {
    // 스토어 url 열기
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
설정의 '이용방법' 버튼을 클릭하면 앱을 처음 설치하고 접속했을 때 보여줬던 튜토리얼을 다시 볼 수 있다. 처음에 튜토리얼을 스킵 해서 어떻게 앱을 사용해야 할지 모르는 사용자를 위해서 구현했다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155328018-232f98a9-48ed-4ede-9340-728da4b90874.jpeg" width="200"></p>

<br/>

### 로그아웃
로그아웃은 유저가 익명인 경우를 다뤄줘야 한다. 익명인 경우에는 로그아웃 처리가 된 후에 다시 익명으로 로그인하게 되면 이전과 다른 새로운 아이디로 가입되기 때문이다. 

그래서 우선 FirebaseAuth 프레임워크를 통해 현재 사용자가 익명인지 확인한다. 익명이라면 FirebaseDatabase 프레임워크를 통해 해당 데이터베이스 경로에 있는 데이터를 삭제하고 로그인 화면으로 이동한다.

익명이 아닌 사용자라면 로그아웃 처리만 하고 로그인 화면으로 이동한다. 그러면 다음에 앱에 접속했을 때 이전에 로그아웃 처리가 되었기 때문에 다시 로그인해야 한다.

<br/>

```swift
// 로그아웃
@IBAction func logoutButtonTapped(_ sender: UIButton) {
    let isAnonymous = Auth.auth().currentUser?.isAnonymous
    let alertController = UIAlertController(
        title: "로그아웃",
        message: "정말 로그아웃하시겠습니까?",
        preferredStyle: UIAlertController.Style.alert
    )

    let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)

    let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
        guard let self = self else { return }

        // 익명 유저이면 유저 데이터 삭제하고 로그인 화면으로 이동하기
        if isAnonymous! {
            self.ref.child("User/\(self.uid!)").removeValue()
            Auth.auth().currentUser?.delete(completion: { error in
                if let error = error {
                    print("ERROR: CurrentUser Delete\(error.localizedDescription) ")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        } else {
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("ERROR: signout \(signOutError.localizedDescription)")
            }
        }
    }

    alertController.addAction(cancelAction)
    alertController.addAction(confirmAction)
    self.present(alertController, animated: true, completion: nil)
}
```

<br/>

### 앱 버전 가져오기
설정화면에 현재 앱의 버전과 앱스토어에 출시된 최신 버전을 표시하도록 구현했다. 현재 버전은 infoDictionary에 키값으로 접근하여 가져왔고, 최신 버전은 '모닥이' 앱의 번들 아이디를 포함한 URL을 통해 앱스토어에 출시된 '모닥이'의 정보를 JSON 형식으로 읽어온 후 가져왔다.

<br/>

```swift
// Version
currentVersionLabel.text = "현재 버전 : \(self.getCurrentVersion())"
updatedVersionLabel.text = "최신 버전 : \(self.getUpdatedVersion())"
        
// 현재 버전 가져오기
func getCurrentVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
    return version
}

// 최신 버전 가져오기
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

<!-- 7. 앱 추적 권한 -->
## 📍 앱 추적 권한
사용자에게 맞춤형 광고를 제공하기 위해서 앱을 처음 설치하고 실행할 때 앱 추적 권한을 요청한다.

<br/>

```swift
import AdSupport
import AppTrackingTransparency

...

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 앱 추적 권한 요청
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:           // 허용됨
                        print("Authorized")
                        print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
                    case .denied:               // 거부됨
                        print("Denied")
                    case .notDetermined:        // 결정되지 않음
                        print("Not Determined")
                    case .restricted:           // 제한됨
                        print("Restricted")
                    @unknown default:           // 알려지지 않음
                        print("Unknow")
                    }
                }
            }
        }

        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
```

<br/>

<!-- 8. 화면 및 디자인 -->
## 🌈 화면 및 디자인
### Accent Color

모닥이의 상징인 따뜻한 모닥불이 연상되는 '다홍색'을 포인트 색상으로 넣었다.

<br/>

<p align="left"><img src="https://user-images.githubusercontent.com/49383370/155312772-f11a795b-02f3-41b7-a48c-8bf855998449.png"></p>

<br/>

### App Icon

아이콘도 모닥이의 상징인 모닥불을 표현하기 위해서 포인트 색상으로 칠한 불 이미지로 구성했다. 모닥이를 통해서 모두의 마음이 따뜻해지길 바람을 표현한 것이다.

<br/>

<p align="left"><img src="https://user-images.githubusercontent.com/49383370/155313186-0e16889a-f425-4434-a019-8c734ef2ec19.png" width="100"></p>

<br/>

### UI/UX

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/155319015-783e1a1c-59e6-4ac0-b1a0-6d7bb0e8c95b.png"></p>

<br/>

<!-- 9. 이번에 처음 다룬 것 -->
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
글귀를 텍스트 또는 이미지로 공유하기 위해서 UIActivityViewController를 처음 사용해 봤다. 이 뷰를 PopOver 형식으로 띄우게 설정해서 iPad에서는 위치를 정해줘야 했다. 이 문제 때문에 한 번 리젝됬지만 잘 해결했다.

> 내용 정리: https://velog.io/@minji0801/iOS-Swift-텍스트-또는-이미지-공유하기

<br/>

### 5. MessageUI
Mail 앱을 이용해서 개발자에게 피드백을 보내기 위해서 MessageUI를 처음 다뤄보았다. 시뮬레이터에서는 Mail 앱이 실행되지 않기 때문에 실기기로 테스트했다. 그리고 메일 전송을 실패했을 때 Alert 창을 띄우고 사용자가 Mail 앱을 설치하거나 이메일 설정을 확인하도록 유도했다.

> 내용 정리: https://velog.io/@minji0801/iOS-Swift-iOS-기기에서-Mail-앱-이용해서-이메일-보내는-방법

<br/>

<!-- 10. 만나러 가기 -->
## 👀 만나러 가기
### App Store
> https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726

### Notion
> https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7

### Gmail
> modakyi.help@gmail.com

<br/>

<!-- 11. 버전 기록 -->
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

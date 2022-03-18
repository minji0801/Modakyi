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
6. [Detail](#Detail)
7. [Favorite and Unused](#Favorite-and-Unused)
8. [Search](#Search)
9. [Settings](#Settings)
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

<!-- 6. Detail -->
## Detail
This is the screen that appears when you click a cell. You can check whether you like or used the phrase, and you can share it as text or an image. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Detail)

<p align="left"><img alt="detail" width="200" src="https://user-images.githubusercontent.com/49383370/158944623-f1bfe149-fb7a-47b1-a0d5-3adf373dce8f.png"></p>

<br/>

When this screen is displayed, the ```text ID``` is passed, and text information is retrieved with this id.

Like and used is checked every time the screen is shown (viewWillAppear). Access the ```User/(user uid)/like``` and ```User/(user uid)/used``` paths to get the favorite texts IDs (likeTextIDs) and used texts IDs (usedTextIDs), respectively. If the id of the current text is included here, the button is displayed as selected.

When the text or image sharing button is clicked, a notification is received from the ```NotificationCenter``` and the sharing screen is displayed.


<br/>

<!-- 7. Favorite and Unused -->
## Favorite and Unused
This is a screen where user can see only the texts that user like. Access the ```User/(useruid)/like``` path to get the ID of the text that the user likes. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Like)

<p align="left"><img alt="favorite" width="200" src="https://user-images.githubusercontent.com/49383370/158946521-fefeb400-455a-48aa-8a36-146e18701880.png"></p>

<br/>

This is a screen where the user can see only the texts that have not been used yet. Access the ```User/(useruid)/used``` path and get the opposite value of the ID of the text used by the user. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Unused)

<p align="left"><img alt="미사용" width="200" src="https://user-images.githubusercontent.com/49383370/158947865-cab3a02a-dea9-4d65-a0a3-d60c9f6fe496.png"></p>

<br/>

<!-- 8. Search -->
## Search
You can find texts that contain search values. Implemented the SearchBar action by inheriting ```UISearchBarDelegate```. If you enter a search term and click the search button, the search result is derived through the filter statement and displayed in CollectionView. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Search)

<p align="left"><img alt="search" width="200" src="https://user-images.githubusercontent.com/49383370/158949136-208c9b5f-de55-4410-9ced-c057bf525a7d.png"></p>

<br/>

<!-- 9. Settings -->
## Settings
Various functions such as notification setting, theme change, font change, notice, inquiry and opinion, app evaluation, usage method, version information, account information, and logout are provided on the setting screen. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Setting)

<p align="left"><img alt="settings" width="200" src="https://user-images.githubusercontent.com/49383370/158952311-e1fa74d3-a034-44aa-8eeb-0e9eeb245b9e.png"></p>

<br/>

- ### Notification settings
  The goal was to control it with a switch button, but I couldn't achieve it. Therefore, it was implemented by moving to the basic setting screen.

### 사용자 정보 가져오기
모닥이의 설정화면에서는 현재 로그인한 유저의 프로필 이미지와 닉네임을 확인할 수 있다. **FirebaseAuth**를 이용해서 현재 로그인한 사용자의 정보를 가져와 UI Component에 뿌려준다.

<br/>

### 다크 모드
UserDefaults를 이용해서 키가 **'Appearance'인 곳에 다크 모드를 저장**시켜놓고, ViewController의 viewWillAppear에서 호출되는 appearanceCheck() 함수를 통해서 현재 앱에 설정되어 있는 모드를 적용시키도록 구현했다.

<br/>

### 공지사항
공지사항은 말 그대로 사용자에게 간단한 공지나 앱 버전 업데이트 관련 내용을 보여주기 위한 화면이다.

<br/>

<p align="center"><img alt="공지" src="https://user-images.githubusercontent.com/49383370/156299028-3922cad8-6b3d-410b-bbe7-b673cfb88858.png" width="200"></p>

<br/>

### 문의 및 의견
MessageUI 프레임워크를 이용하여 Mail 앱을 통해 이메일을 작성하는 화면을 보여주고, 메일을 작성하여 개발자에게 보낼 수 있다. 메일 보내기에 실패한 경우 Alert 창을 띄워 사용자가 Mail 앱을 설치하거나 이메일 설정을 확인할 수 있도록 구현했다.

<br/>

### 앱 평가
'앱 평가' 버튼을 클릭하면 App Store 모닥이 앱 페이지로 이동하여 사용자가 앱을 평가할 수 있도록 구현했다.

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

### 앱 버전 가져오기
설정화면에 현재 앱의 버전과 앱스토어에 출시된 최신 버전을 표시하도록 구현했다. 현재 버전은 infoDictionary에 키값으로 접근하여 가져왔고, 최신 버전은 '모닥이' 앱의 번들 아이디를 포함한 URL을 통해 앱스토어에 출시된 '모닥이'의 정보를 JSON 형식으로 읽어온 후 가져왔다.

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

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
11. [First time dealing with thise](#First-time-dealing-with-this)
12. [Contact](#Contact)
13. [Version History](#Version-History)

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
    let id: String      // Text id
    let kor: String     // Korean
    let eng: String     // English
    let who: String     // The person who spoke the text
    let time: String    // Upload time
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

Like and used is checked every time the screen is shown (viewWillAppear). Access the ```User/(userUid)/like``` and ```User/(userUid)/used``` paths to get the favorite texts IDs (likeTextIDs) and used texts IDs (usedTextIDs), respectively. If the id of the current text is included here, the button is displayed as selected.

When the text or image sharing button is clicked, a notification is received from the ```NotificationCenter``` and the sharing screen is displayed.

<br/>

<!-- 7. Favorite and Unused -->
## Favorite and Unused
This is a screen where user can see only the texts that user like. Access the ```User/(userUid)/like``` path to get the ID of the text that the user likes. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Like)

<p align="left"><img alt="favorite" width="200" src="https://user-images.githubusercontent.com/49383370/158946521-fefeb400-455a-48aa-8a36-146e18701880.png"></p>

<br/>

This is a screen where the user can see only the texts that have not been used yet. Access the ```User/(userUid)/used``` path and get the opposite value of the ID of the text used by the user. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Unused)

<p align="left"><img alt="미사용" width="200" src="https://user-images.githubusercontent.com/49383370/158947865-cab3a02a-dea9-4d65-a0a3-d60c9f6fe496.png"></p>

<br/>

<!-- 8. Search -->
## Search
You can find texts that contain search values. Implemented the SearchBar action by inheriting ```UISearchBarDelegate```. If you enter a search term and click the search button, the search result is derived through the filter statement and displayed in CollectionView. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Search)

<p align="left"><img alt="search" width="200" src="https://user-images.githubusercontent.com/49383370/158949136-208c9b5f-de55-4410-9ced-c057bf525a7d.png"></p>

<br/>

<!-- 9. Settings -->
## Settings
Various functions such as notification setting, theme change, font change, notice, inquiry and opinion, app rating, how to use, version information, account information, and logout are provided on the setting screen. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Setting)

<p align="left"><img alt="settings" width="200" src="https://user-images.githubusercontent.com/49383370/158952311-e1fa74d3-a034-44aa-8eeb-0e9eeb245b9e.png"></p>

<br/>

- ### Notification settings
  The goal was to control it with a switch button, but I couldn't achieve it. Therefore, it was implemented by moving to the basic setting screen.

- ### Change themes and fonts
  You can change the theme and font of the app. By using ```ThemeManager``` and ```FontManager```, values are stored in ```UserDefaults```, loaded and applied. Code is [here](https://github.com/minji0801/Modakyi/tree/main/Modakyi/Manager)
  
- ### Notice
  It is a screen to notify simple announcements or updated contents.

- ### Inquiries and comments
  It shows the email composing screen using the ```MessageUI``` framework. You can write an email and send it to the developer. If sending mail fails, an Alert window is displayed to notify the user to install the Mail app or check the email settings.

- ### App rating
  Go to the App Store review writing screen. By sending ```"write-review"``` to the ```URLQueryItem```, it immediately brings up the review writing screen.

- ### How to use
  Shows the tutorial screen that appears when you first install and access the app.

- ### Version information
  This screen shows the current version and the latest version. The current version was retrieved by accessing ```Bundel.main.infoDictionary``` as a key value, and the latest version was retrieved after reading the information of 'Modaki' released in the App Store in JSON format.

- ### Account information
  You can check the profile image, nickname, email, and login method of the currently logged in user. Get the information of the currently logged in user using ```FirebaseAuth```.

- ### Log out
  Logs out the currently logged in user. If the user is anonymous, the account will be deleted upon logout, so user data must also be deleted.

  It checks whether the current user is anonymous through ```isAnonymous``` of ```FirebaseAuth```. If it is an anonymous user, delete the data in the User/(userUid) path and go to the login screen.

  If it is not, it only handles logout and moves to the login screen. When you access the app again, the login screen is displayed because user have previously logged out.

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

<!-- 11. First time dealing with thise -->
## First time dealing with this
- ### Firebase(RealtimeDatabase, FCM, Authentication)
  Previously, data was stored locally on the device using UserDefaults, but this time the data is stored in Firebase's Realtime Database, a cloud service.

  In addition, FCM (Firebase Cloud Messaging) was used to send a daily new text upload notification to the user's device, and using an authentication service, email login, social (Google, Apple) login, and anonymous login were also implemented.

- ### AdMob interstitial
  An interstitial advertisement was added along with the AdMob banner advertisement that was dealt with during the development of 'Scoit'. An interstitial ad is displayed whenever the detailed screen that appears when a text is clicked is dismissed. I made the interstitial ad object into a variable and set the root view of the object as the current screen and opened it.

- ### Get version information
  I wanted to show the current version of the app on the settings screen and the latest version released on the app store, so I tried this for the first time. I think it's a very useful feature because it's actually used for setting up quite a few apps.

  > Blog: https://velog.io/@minji0801/iOS-현재-버전-최신-버전-확인하는-방법

- ### Share function
  This is my first time using UIActivityViewController to share text as text or image. In order to display this view in a PopOver format, the position had to be determined. It was rejected once because of the problem that an error occurred on the iPad because the location was not specified, but it was resolved.

  > Blog: https://velog.io/@minji0801/iOS-Swift-텍스트-또는-이미지-공유하기

- ### MessageUI
  This is my first time working with MessageUI to send feedback to developers using the Mail app. Since the Mail app does not run in the simulator, we tested it with a real device. And when the mail transmission failed, an Alert window open and the user was prompted to install the Mail app or check the email settings.

  > Blog: https://velog.io/@minji0801/iOS-Swift-iOS-기기에서-Mail-앱-이용해서-이메일-보내는-방법

- ### MVVM refactoring
  Changed from the existing MVC structure to the MVVM structure. There was a lot of confusion about where to write code between ViewController and ViewModel. But I keep thinking that ViewController cannot be directly connected to the Model and is connected through the ViewModel, and I gave the ViewController the things it had to the ViewModel.

<br/>

<!-- 12. Contact -->
## Contact
### App Store
> https://apps.apple.com/kr/app/%EB%AA%A8%EB%8B%A5%EC%9D%B4/id1596424726

### Notion
> https://www.notion.so/4bd9c3e1fe5d46648565a364523ce7b7

### Gmail
> modakyi.help@gmail.com

<br/>

<!-- 13. Version History -->
## Version History
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

<!-- Footer -->
<div align="center">
  <a href="https://github.com/minji0801"><img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=codeSTACKr"/></a>
  
  <br/>
  <br/>
  <br/>
  
  <a href="https://github.com/minji0801/Modakyi"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FModakyi&count_bg=%23E76140&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
</div>

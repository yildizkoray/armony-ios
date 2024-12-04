# Armony iOS

<p align="center">
<img src="/screenshots/armony.png" width="200"/>
</p>

Armony is a platform designed for musicians and those involved in the music industry. It offers users the ability to create a musical profile based on their style and talents, discover music collaborators or companions, and engage in creative projects with inspiring artists to create unique pieces. The app aims to be a new network for both music and musicians, such as musicians, songwriters, composers, mix mastering professionals, podcast editors, music teachers, arrangers, producers, production specialists, remixers, beat makers, sound engineers, and sound designers. Currently, it is available only on the App Store. For more details, you can visit their website at [Armony.app](https://armony.app/).

<br/><br/>

<p align="center">
<img src="/screenshots/Home.png" width="300"/>
<img src="/screenshots/LiveChat.png" width="300"/>
<img src="/screenshots/Profile.png" width="300"/>
</p>

## Project Tech Stack
* Language: Swift
* Minimum iOS Version: 15.0
* Design Pattern: MVVM-C
* Dependency  Manager: Swift Package Manager
* Dependencies: Alamofire, AlamofireImage and [UIScrollView-InfiniteScroll](https://github.com/pronebird/UIScrollView-InfiniteScroll)
* Style Guide: [Raywenderlich](https://github.com/raywenderlich/swift-style-guide)
* Powered by ❤️

## Getting Started

Follow these steps to get started with the project:

### Prerequisites

- [Xcode](https://developer.apple.com/xcode/)
- Access to Firebase and Facebook Developer accounts (to generate required secret keys)

### Installation

Clone the repository:

```bash
git clone git@github.com:studiogo-armony/armony-ios.git
cd armony-ios
```

## Secrets

This project uses sensitive keys for integrations.

### Required Keys

#### Firebase Keys

- `FIREBASE_CLIENT_ID`
- `FIREBASE_REVERSED_CLIENT_ID`
- `FIREBASE_API_KEY`
- `FIREBASE_GCM_SENDER_ID`
- `FIREBASE_PLIST_VERSION`
- `FIREBASE_BUNDLE_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_IS_ADS_ENABLED`
- `FIREBASE_IS_ANALYTICS_ENABLED`
- `FIREBASE_IS_APPINVITE_ENABLED`
- `FIREBASE_IS_GCM_ENABLED`
- `FIREBASE_IS_SIGNIN_ENABLED`
- `FIREBASE_GOOGLE_APP_ID`

#### Facebook Keys

- `FACEBOOK_APP_ID`
- `FACEBOOK_CLIENT_TOKEN`

#### Mixpanel Keys

- `MIXPANEL_TOKEN`

#### Adjust Keys

- `ADJUST_TOKEN`

### Managing Secrets

Store secrets in configuration files specific to your environment:

- Debug Configuration (`${PROJECT_DIR}/Armony/Resources/Configs/DebugConfiguration.xcconfig`)
- Release Configuration (`${PROJECT_DIR}/Armony/Resources/Configs/ReleaseConfiguration.xcconfig`)

## Structure
```bash
⊢ Common
  ⊢ UI
      ⊢ Analytics
      ⊢ Deeplink
      ⊢ Protocols
      ⊢ UI
        ⊢ Banner, Card, Avatar etc
⊢ Service
    ⊢ Firebase
    ⊢ RemoteNotification
    ⊢ Socket
    ⊢ Authentication
⊢ Scenes
  ⊢ Adverts
    ⊢ API
      ⊢ Tasks // Tasks that retrieve any related response coming from API.
    ⊢ Models // Entity for API
    ⊢ UI
        ⊢ Presentation
        ⊢ View
            ⊢ ABCPresentation.swift //Presentation/ViewModel object of ABC
            ⊢ ABCView.swift
            ⊢ ABCView.xib
    ⊢ AdvertsCoordinator.swift
    ⊢ AdvertsViewModel.swift
    ⊢ AdvertsViewController.swift
    ⊢ Home.storyboard
```

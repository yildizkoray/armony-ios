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

# Armony iOS

<p align="center">
<img src="/screenshots/armony.png" width="200"/>
</p>

Armony helps musicians connect with each other. Users can create profiles showing their musical skills and find other musicians to work with. It's perfect for musicians, songwriters, composers, sound engineers, music teachers, producers, and more. You can find it on the App Store or visit [Armony](https://armony.app) for more info.

## Screenshots

<p align="center">
<img src="/screenshots/Home.png" width="300"/>
<img src="/screenshots/LiveChat.png" width="300"/>
<img src="/screenshots/Profile.png" width="300"/>
<img src="/screenshots/adp.png" width="300"/>
<img src="/screenshots/profile-edit.png" width="300"/>
<img src="/screenshots/onboarding.png" width="300"/>
<img src="/screenshots/registration.png" width="300"/>
</p>


## Table of Contents
- [Project Tech Stack](#project-tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Secrets](#secrets)
  - [Required Keys](#required-keys)
  - [Managing Secrets](#managing-secrets)
- [Structure](#structure)
- [SwiftUI Integration](#swiftui-integration)
  - [SwiftUI Screens](#swiftui-screens)
  - [UIKit-SwiftUI Bridge Components](#uikit-swiftui-bridge-components)
  - [Implementation Details](#implementation-details)
- [Coordinator Pattern with SwiftUI](#coordinator-pattern-with-swiftui)
  - [SwiftUI Coordinator Integration](#swiftui-coordinator-integration)
  - [Implementation Example](#implementation-example)
- [Deep Linking](#deep-linking)
  - [Deep Link Structure](#deep-link-structure)
  - [Key Components](#key-components)
  - [Implementation Example](#implementation-example-1)

## Project Tech Stack
* Language: Swift
* UI Frameworks: UIKit & SwiftUI
* Minimum iOS Version: 15.0
* Design Pattern: MVVM-C
* Package Manager: Swift Package Manager
* Main Libraries: Alamofire, AlamofireImage and [UIScrollView-InfiniteScroll](https://github.com/pronebird/UIScrollView-InfiniteScroll)
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

#### Google Configuration Files
- `GoogleService-Info.plist`: For Release builds
- `GoogleService-Info-Debug.plist`: For Debug builds

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

## SwiftUI Integration

This app uses both UIKit and SwiftUI. Here's how we use SwiftUI:

### SwiftUI Screens
* **Regions Screen**: A screen for selecting regions, built with SwiftUI components
* **AdvertListing Screen**: Shows ads in a grid layout
* **Info View**: A simple view to show information with an icon

### UIKit-SwiftUI Bridge Components
We use these components to connect UIKit and SwiftUI:
* `EmptyStateSwiftUIView`: Shows empty states
* `SwiftUICardView`: Shows cards
* `NotchViewSwiftUI`: Shows the notch view
* `PolicyTextView`: Shows text content

### Implementation Details
* Uses MVVM pattern with SwiftUI's @ObservedObject
* Works with our app's theme system
* Combines UIKit and SwiftUI views
* Needs iOS 16+ for some features
* New screens use SwiftUI
* Old UIKit components work with SwiftUI

## Coordinator Pattern with SwiftUI

We use MVVM-C pattern to handle navigation in both UIKit and SwiftUI screens.

### SwiftUI Coordinator Integration
```swift
public typealias Navigator = UINavigationController

public protocol Coordinator {
    associatedtype Controller: ViewController
    var navigator: Navigator? { get }
    
    func createViewController() -> Controller
    func createNavigatorWithRootViewController() -> (navigator: Navigator, view: Controller)
}
protocol SwiftUICoordinator: Coordinator {
    associatedtype Content: View
}
```

This helps us:
* Handle SwiftUI navigation
* Connect SwiftUI views with UIKit navigation
* Keep navigation code organized
* Use SwiftUI views anywhere in the app
* Mix UIKit and SwiftUI screens
* Control all navigation from coordinators
* Use SwiftUI in tab bars

### Implementation Example
```swift
final class MyCoordinator: SwiftUICoordinator {
    var navigator: Navigator?
    
    typealias Content = MySwiftUIView
    typealias Controller = UIHostingController<MySwiftUIView>
    
    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }
    
    func start() {
        let viewModel = MySwiftUIViewModel()
        viewModel.coordinator = self
        let view = MySwiftUIView(viewModel: viewModel)
        let hosting = createHostingViewController(rootView: view)
        hosting.title = "TITLE"
        navigator?.pushViewController(hosting, animated: true)
    }
}
```

With this setup, SwiftUI views:
* Work with UIKit navigation
* Use the same navigation system
* Support deep linking
* Match the app's style

## Deep Linking

Our app uses deep links to open specific screens directly. It's built with a custom URL system.

### Deep Link Structure
```swift
public extension Deeplink {
    static let account: Deeplink = "/account"
    static let advert: Deeplink = "/advert"
    static let chats: Deeplink = "/chats"
    static let liveChat: Deeplink = "/live-chat"
    // ... and more
}
```

### Key Components

#### URLNavigator
* Controls all deep link navigation
* Handles URL patterns
* Checks if user is logged in
* Works with coordinators
* Prevents typing mistakes
* Can pass data through URLs
* Uses app's own URL format

#### URLNavigatable Protocol
```swift
public protocol URLNavigatable {
    var isAuthenticationRequired: Bool { get }
    static var instance: URLNavigatable { get }
    static func register(navigator: URLNavigation)
}
```

### Implementation Example
Here's how to add deep linking to a coordinator:
```swift
extension MyCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool { true }
    
    static var instance: URLNavigatable {
        return MyCoordinator()
    }
    
    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .myScreen) { result in
            MyCoordinator(navigator: result.navigator).start()
        }
    }
}
```

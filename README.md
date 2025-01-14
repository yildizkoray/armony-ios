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
- [GitHub Actions Scripts](#github-actions-scripts)
  - [Create Release Branch](#create-release-branch)
  - [Merge Release to Main](#merge-release-to-main)
  - [Merge Main to Development](#merge-main-to-development)
- [CI Scripts](#ci-scripts)
  - [Pre-Xcodebuild Script](#pre-xcodebuild-script)
  - [Post-Clone Script](#post-clone-script)
  - [Post-Xcodebuild Script](#post-xcodebuild-script)
- [Networking](#networking)

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
* Can pass data through URLs

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
        if let id = result.value(forKey: "id") as? String {
            MyCoordinator(navigator: result.navigator, id: id).start()
        }
    }
}
```

## GitHub Actions Scripts

Our project uses GitHub Actions for automated workflows. Here are the main workflows:

### Create Release Branch
This workflow automates the creation of release branches with version increments:
```yaml
# Triggered manually with version type choice
- Automatically increments version (major, minor, or patch)
- Creates a new release branch from development
- Updates the marketing version in Xcode project
```

### Merge Release to Main
This workflow handles merging release branches to the main branch:
```yaml
# Can be triggered manually or automatically
- Merges the latest release branch to main
- Supports manual selection of release branch
- Uses no-fast-forward merge strategy
```

### Merge Main to Development
This workflow keeps the development branch in sync with main:
```yaml
# Triggers:
- Automatically after successful release merge
- Manually when needed
- Ensures development branch stays updated with main
```

## CI Scripts

Our project includes several CI scripts in the `ci_scripts` directory that handle different stages of the build process. These scripts are designed to work with both Xcode Cloud and other CI environments.

### Pre-Xcodebuild Script
`ci_pre_xcodebuild.sh` runs before the build process starts:
```bash
# Main responsibilities:
- Validates required environment variables
- Sets up configuration files for different environments (Debug/Release)
- Configures third-party service integrations
- Updates necessary plists and configuration files
```

### Post-Clone Script
`ci_post_clone.sh` runs after repository cloning:
```bash
# Main responsibilities:
- Creates necessary directory structure
- Sets up configuration files
- Initializes required plists
- Prepares the environment for building
```

### Post-Xcodebuild Script
`ci_post_xcodebuild.sh` runs after the build process:
```bash
# Main responsibilities:
- Handles debug symbol uploads
- Processes build artifacts
- Performs necessary post-build tasks
```

## Networking

Our project uses a layered networking architecture that provides type-safe API requests. Here's how it works:

### RestService
The core service class that handles all network operations:
```swift
class RestService: Service {
    func execute<R: APIResponse>(task: HTTPTask, type: R.Type) async throws -> R
}
```

### Response Types
- `RestObjectResponse<T>`: For single object responses
- `RestArrayResponse<T>`: For array responses
- Built-in error handling with `RestErrorResponse`

### HTTPTask Protocol
Each API endpoint is represented by a task that implements `HTTPTask`:
```swift
struct GetMyNetworkTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/my-network"
    var urlQueryItems: [URLQueryItem]?
    
    init(userID: String) {
        urlQueryItems = [
            URLQueryItem(name: "userID", value: userID)
        ]
    }
}
```

### Usage Example
```swift
// Create the task
let task = GetMyNetworkTask(userID: "123")

// Execute the request
Task { 
    do {
        let response = try await restService.execute(
            task: task, 
            type: RestArrayResponse<MyNetworkModel>.self
        )
        // Handle response
    } catch {
        // Handle error
    }
}
```
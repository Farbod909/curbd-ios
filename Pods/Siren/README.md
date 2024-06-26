# Siren 🚨

### Notify users when a new version of your app is available and prompt them to upgrade.

[![Travis CI Status](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master)](https://travis-ci.org/ArtSabintsev/Siren) ![Swift Support](https://img.shields.io/badge/Swift-4.2%2C%204.1%2C%203.2%2C%203.1%202.3-orange.svg) ![Documentation](https://github.com/ArtSabintsev/Siren/blob/master/docs/badge.svg) [![CocoaPods](https://img.shields.io/cocoapods/v/Siren.svg)](https://cocoapods.org/pods/Siren)  [![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

---

## Table of Contents
- [About](https://github.com/ArtSabintsev/Siren#about)
- [Features](https://github.com/ArtSabintsev/Siren#features)
- [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots)
- [Installation Instructions](https://github.com/ArtSabintsev/Siren#installation-instructions)
- [Implementation Examples](https://github.com/ArtSabintsev/Siren#example-code)
- [Localization](https://github.com/ArtSabintsev/Siren#localization)
- [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility)
- [Testing Siren](https://github.com/ArtSabintsev/Siren#testing-siren)
- [App Store Review & Submissions](https://github.com/ArtSabintsev/Siren#app-store-submissions)
- [Phased Releases](https://github.com/ArtSabintsev/Siren#phased-releases)
- [Words of Caution](https://github.com/ArtSabintsev/Siren#words-of-caution)
- [Ports](https://github.com/ArtSabintsev/Siren#ports)
- [Shout-Out and Gratitude](https://github.com/ArtSabintsev/Siren#shout-out-and-gratitude)
- [Attribution](https://github.com/ArtSabintsev/Siren#created-and-maintained-by)

---

## About
**Siren** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store.

If a new version is available, an alert can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app programmatically, enabling you to inform the user through alternative means, such as a custom interface.

- Siren is built to work with the [**Semantic Versioning**](https://semver.org/) system.
	- Canonical Semantic Versioning uses a three number versioning system (e.g., 1.0.0)
	- Siren also supports two-number versioning (e.g., 1.0) and four-number versioning (e.g., 1.0.0.0)

## Features

### Current Features
- [x] CocoaPods, Carthage, and Swift Package Manager Support
- [x] Three Types of Alerts (see [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots))
- [x] Highly Customizable Presentation Rules [Implementation Examples](https://github.com/ArtSabintsev/Siren#implementation-examples))
- [x] Localized for 40+ Languages (see [Localization](https://github.com/ArtSabintsev/Siren#localization))
- [x] Device Compatibility Check (see [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility))
- [x] 100% Documentation Coverage 

### Future Features
- [ ] Present prompt only on WiFi if app is over the OTA limit.
- [ ] Support for Third-/Homegrown Update Servers (not including TestFlight).
- [ ] Increase code coverage with more unit tests and UI tests.


## Screenshots
- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `Rules.AlertType` enum.

<img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picForcedUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picOptionalUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picSkippedUpdate.png?raw=true" height="480">


## Installation Instructions

| Swift Version |  Branch Name  | Will Continue to Receive Updates?
| ------------- | ------------- |  -------------
| 4.2  | master | **Yes**
| 4.1  | swift4.1 | No
| 3.2  | swift3.2 | No
| 3.1  | swift3.1 | No
| 2.3  | swift2.3 | No  

### CocoaPods
```ruby
pod 'Siren' # Swift 4.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift4.1' # Swift 4.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.2' # Swift 3.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.1' # Swift 3.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift2.3' # Swift 2.3
```

### Carthage
```swift
github "ArtSabintsev/Siren" // Swift 4.2
github "ArtSabintsev/Siren" "swift4.1" // Swift 4.1
github "ArtSabintsev/Siren" "swift3.2" // Swift 3.2
github "ArtSabintsev/Siren" "swift3.1" // Swift 3.1
github "ArtSabintsev/Siren" "swift2.3" // Swift 2.3
```

### Swift Package Manager
```swift
.Package(url: "https://github.com/ArtSabintsev/Siren.git", majorVersion: 4)
```

## Implementation Examples
Implementing Siren is as easy as adding two line of code to your app. 

```swift
import Siren // Line 1
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

		Siren.shared.wail() // Line 2

        return true
    }
}
```

Siren also has plenty of customization options. All examples can be found in the Example Project's [**AppDelegate**](https://github.com/ArtSabintsev/Siren/blob/master/Example/Example/AppDelegate.swift) file. Uncomment the example you'd like to test.
 

**WARNING**: Siren should ONLY be placed in [UIApplication.didFinishLaunchingWithOptions](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application) and only after the `window?.makeKeyAndVisible()` call. Siren initializes a listener on [didBecomeActiveNotification](https://developer.apple.com/reference/foundation/nsnotification.name/1622953-uiapplicationdidbecomeactive) to perform version checks.

## Localization
Siren is localized for the following languages:

Arabic, Armenian, Basque, Chinese (Simplified and Traditional), Croatian, Czech, Danish, Dutch, English, Estonian, Finnish, French, German, Greek, Hebrew, Hungarian, Indonesian, Italian, Japanese, Korean, Latvian, Lithuanian, Malay, Norwegian (Bokmål), Persian (Afghanistan, Iran, Persian), Polish, Portuguese (Brazil and Portugal), Russian, Serbian (Cyrillic and Latin), Slovenian, Spanish, Swedish, Thai, Turkish, Ukrainian, Urdu, Vietnamese

You may want the update dialog to *always* appear in a certain language, ignoring the user's device-specific setting. You can enable it like so:

```swift
// In this example, we force the `russian` language.
Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .russian)
```

## Device Compatibility
If an app update is available, Siren checks to make sure that the version of iOS on the user's device is compatible with the one that is required by the app update. For example, if a user has iOS 11 installed on their device, but the app update requires iOS 12, an alert will not be shown. This takes care of the *false positive* case regarding app updating.

## Testing Siren
Temporarily change the version string in Xcode (within the `.xcodeproj` file) to an older version than the one that's currently available in the App Store. Afterwards, build and run your app, and you should see the alert.

If you currently don't have an app in the store, change your bundleID to one that is already in the store. In the sample app packaged with this library, we use the [App Store Connect](https://itunes.apple.com/app/id1234793120) app's bundleID: `com.apple.AppStoreConnect`.

## App Store Submissions
The App Store reviewer will **not** see the alert. The version in the App Store will always be older than the version being reviewed.

## Phased Releases
In 2017, Apple announced the [ability to rollout app updates gradually (a.k.a. Phased Releases)](https://itunespartner.apple.com/en/apps/faq/Managing%20Your%20Apps_Submission%20Process). Siren will continue to work as it has in the past, presenting an update modal to _all_ users. If you opt-in to a phased rollout for a specific version, you have a few choices:

- You can leave Siren configured as normal. Phased rollout will continue to auto-update apps. Since all users can still manually update your app directly from the App Store, Siren will ignore the phased rollout and will prompt users to update.
- You can set `showAlertAfterCurrentVersionHasBeenReleasedForDays` to `7`, and Siren will not prompt any users until the latest version is 7 days old, after the phased rollout is complete.
- You can remotely disable Siren until the rollout is done using your own API / backend logic.

## Words of Caution
Occasionally, the iTunes JSON will update faster than the App Store CDN, meaning the JSON may state that the new version of the app has been released, while no new binary is made available for download via the App Store. It is for this reason that Siren will, by default, wait 1 day (24 hours) after the JSON has been updated to prompt the user to update. To change the default setting, please modify the value of `showAlertAfterCurrentVersionHasBeenReleasedForDays`.

## Ports
- **Objective-C (iOS)**
   - [**Harpy**](https://github.com/ArtSabintsev/Harpy)
   - Siren was ported _from_ Harpy, as Siren and Harpy are maintained by the same developer.
   - As of December 2018, Harpy has been deprecated in favor of Siren.
- **Java (Android)**
   - [**Egghead Games' Siren library**](https://github.com/eggheadgames/Siren)
   - The Siren Swift library inspired the Java library.
- **React Native (iOS)**
   - [**Gant Laborde's Siren library**](https://github.com/GantMan/react-native-siren)
   - The Siren Swift library inspired the React Native library.

## Shout-Out and Gratitude
A massive shout-out and thank you goes to the following folks: 

- [Aaron Brager](https://twitter.com/@getaaron) for motivating me and assisting me in building the initial proof-of-concept of Siren (based on [Harpy](https:github.com/ArtSabintsev/Harpy)) back in 2015. Without him, Siren may never have been built. 
- All of [Harpy's Consitrbutors](https://github.com/ArtSabintsev/Harpy/graphs/contributors) for helping building the feature set from 2012-2015 that was used as the basis for the first version of Siren.
- All of [Siren's Contributors](https://github.com/ArtSabintsev/Siren/graphs/contributors) for helping make Siren as powerful and bug-free as it currently is today.

## Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/)

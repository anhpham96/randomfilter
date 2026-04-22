
# 📸 Random Filter  
  
<p align="center">
  <img src="https://github.com/anhpham96/randomfilter/blob/feature/readme/Demo/AppIcon-Dev.png?raw=true" width="200" />
  <img src="https://github.com/anhpham96/randomfilter/blob/feature/readme/Demo/AppIcon-Production.png?raw=true" width="200" />
</p>

Random Filter is a camera app that lets you capture videos with **randomly selected filters**.  

## Demo
https://www.youtube.com/shorts/Vjt1BDBk4mY

## 🚀 Build  
  
### 1. Clone  
  
```bash  
git clone hhttps://github.com/anhpham96/randomfilter
```

### 2. Open project

open RandomFilter.xcodeproj

### 3. Run

-   Select **scheme**: `RandomFilter-dev` or `RandomFilter-production`
-   Choose a **device**:
    -   Real iPhone (recommended for camera testing)
    -   or Simulator
-   Press `Cmd + R` to build & run

**If using a real device, make sure it’s connected and trusted**

## 🏗 Architecture

- **Selected architecture:** MVVM (Model – View – ViewModel)

### 🤔 Why I use MVVM Architecture
- Separates UI and business logic clearly
- Reduces coupling between View and logic
- Makes code easier to maintain and scale
- Improves testability (especially ViewModel)
- Fits well with SwiftUI data binding

## 🚀 Features

### 🎬 Splash & Onboarding
- **Splash View**
- **Interactive Onboarding**
  - Slot Machine View
  - Car Box Selection
  - Social Media View

### 💰 Monetization
- **Paywall View**
- **AdMob Integration**

### 📷 Home View (Camera)
- Camera Preview
- Record Video
- Limit Recording Duration
- Countdown Timer
- Toggle Flash (if supported)
- Flip Camera
- Zoom In / Out Feature
- Permission Denied View  
  _(Prompt user to enable Camera & Microphone in Settings)_
- Premium Button

### 🎞 Result View
- Save Video
- Retry Recording
- Share Video

### 🧠 Data & Configuration
- Store First Open flag (to control onboarding display)
- Save Package ID for Paywall View

### ⚙️ Environment Configuration
- Setup Dev & Production environment
- Separate configuration for each environment (Admob_Id, AppIcon)

## 🧭 Future Improvements
### 🌍 Localization
- Support multiple languages for UI text
- Use `Localizable.strings` structure

### 🎥 Video Recording (GPU Pipeline Upgrade)
- Current:
  - Uses GCD for background processing and task coordination
  - Recording pipeline is not fully GPU-based
  - Uses `CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)` for processing
  - Using `AVAssetWriter` with `CVPixelBuffer` pipeline
  - Prepare frame buffers in advance for later GPU processing

- Improvement direction:
  - Feed `CVPixelBuffer` directly into Metal pipeline
  - Replace CoreImage-based processing with Metal shaders
  - Minimize CPU involvement during frame rendering
  - Improve real-time performance for filters/effects
  - Reduce latency between capture and write-to-file
  
### 🎨 Video Filters
- Current status:
  - No video filter system implemented yet
- Future direction (if time permits):
  - Research and design a frame-based video rendering pipeline (game loop style) 
  - Integrate filter system into rendering loop
  - Explore Metal-based shader filters for better performance  
  - Rebuild architecture to support reusable filter pipeline for both preview + recording
  - Each filter is an independent component (plug & play), supporting dynamic switching / stacking multiple filters

### 💳 In-App Purchase & Subscription

- **RevenueCat (implement first)**
  - Manage subscriptions, entitlements, paywall, restore purchases
  - Sync package ID with Paywall View
  - Handle sandbox & production environments

- **StoreKitHelper (later)** https://github.com/jaywcjlove/StoreKitHelper
  - Integrate after RevenueCat stable
  - Reduce StoreKit boilerplate code
  
### 📢 Ad Integration Issue (AdMob → AppLovin Migration)

- Current status:
  - AdMob SDK is integrated for displaying ads
  - Issue observed on some devices and also appears across multiple apps
  - Problem: Interstitial ads sometimes cannot be closed properly (blocking UI / stuck state)

- Root concern:
  - Inconsistent behavior of AdMob Interstitial Ads across device models and OS versions
  - Possible SDK lifecycle / presentation timing issue

- Solution direction:
  - Migrate Interstitial Ads from AdMob to AppLovin
  - Keep AdMob for other ad formats if needed (e.g., banner / backup network)
  
### 🧩 Refactor & Testing
- Refactor codebase to reduce coupling between modules
- Apply clean architecture principles (separation of concerns)
- Introduce dependency injection for better testability
- Extract business logic away from UI layer

### 🧪 Unit Testing
- Write unit tests for core business logic
- Mock dependencies to isolate test cases
- Ensure critical flows are covered:
  - Camera recording flow
  - Subscription / Paywall logic
  - Filter pipeline (future)

### 🚀 CI/CD (Xcode Cloud)
- Setup Xcode Cloud for automated build & deploy
- Configure workflows for:
  - Dev (internal testing / TestFlight)
  - Production (App Store release)
- Automate:
  - Build & archive
  - Unit test execution
  - Beta distribution via TestFlight
- Manage environment configs (Dev / Prod) via scheme

### 🧨 Crashlytics Integration
- Integrate **Firebase Crashlytics** to track app crashes
- Automatically log crash reports and stack traces
- Help identify and fix issues in production quickly
- Support real-time crash monitoring and analytics
- Improve app stability and user experience over time

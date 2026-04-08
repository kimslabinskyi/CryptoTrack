# CryptoTrack 🪙

A clean, intuitive, and highly responsive iOS application for tracking cryptocurrency prices.
Inspired by Apple's Human Interface Guidelines.

<img width="1080" height="1350" alt="561_1x_shots_so" src="https://github.com/user-attachments/assets/6ddd4942-b99b-43ef-b042-bc7e1edb0170" />
<img width="1080" height="1350" alt="139_1x_shots_so" src="https://github.com/user-attachments/assets/cbcf07a5-fb1a-496c-b544-ebbc6c8eeea3" />
<img width="1080" height="1350" alt="101_1x_shots_so" src="https://github.com/user-attachments/assets/4463eac4-ef3f-45b7-86ec-8f9042b1914e" />
<img width="1080" height="1350" alt="959_1x_shots_so" src="https://github.com/user-attachments/assets/757ac587-c5c2-44ee-a6d1-8e4ae144ef35" />


## ✨ Key Features

* **Interactive Price Charts:** Scalable and interactive line charts displaying up to 365 days of historical data.
* **Haptic Feedback:** Immersive tactile feedback when scrubbing through chart values.
* **iOS Widgets:** Quick glance at your favorite coins right from your Home Screen and Lock Screen (built natively with SwiftUI).
* **Offline Caching:** Offline support powered by local database caching.
* **Dark Mode Ready:** Beautifully crafted UI that perfectly adapts to iOS Dark/Light appearances.

## 🛠 Tech Stack

* **Language:** Swift 5
* **UI Frameworks:** UIKit (Interface Builder) for the main app, SwiftUI for Widgets.
* **Architecture:** MVC with a dedicated Network Service layer.
* **API:** [CoinGecko API](https://www.coingecko.com/en/api) (Optimized to work smoothly within free-tier rate limits).
* **Package Dependencies (SPM):**
  * **[Alamofire](https://github.com/Alamofire/Alamofire):** Used with `@escaping` closures for robust asynchronous API calls.
  * **[DGCharts](https://github.com/danielgindi/Charts):** Powers the scalable and interactive cryptocurrency price line charts.
  * **[RealmSwift](https://realm.io/):** Handles heavy local database caching for offline support and fast load times (complemented by `UserDefaults` for lightweight preferences).

## 🧑‍💻 Development & Under the Hood

The primary goal of this project was to build a production-ready application with a clean codebase. 
* Network requests are decoupled into a standalone `NetworkManager` to keep ViewControllers lightweight.
* Real-time data fetching is balanced with Realm caching to minimize API calls and bypass CoinGecko's free-tier limitations effectively.
* The main dashboard utilizes a complex `UICollectionView` layout with custom cells for data presentation.

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/kimslabinskyi/CryptoTrack.git](https://github.com/kimslabinskyi/CryptoTrack.git)
   
2. Make sure you have the latest version of Xcode installed.

3. Open the CryptoTrack.xcodeproj file.

4. Wait a few seconds for Xcode to automatically resolve SPM dependencies.

5. Build and run the project (Cmd + R). 

## 🔮 Future Roadmap

**Technical Improvements** 
- [ ] Implement Combine or async/await for network calls.
- [ ] Migrate architecture from MVC to MVVM.
- [ ] Set up CI/CD pipeline using GitHub Actions.

**Features**
- [ ] Refactor and expand SwiftUI Widgets.
- [ ] Support multiple fiat currencies (USD, EUR, PLN, etc.).

--- 

*Designed and developed by **Kim Slabinskyi***

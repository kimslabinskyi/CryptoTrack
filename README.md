# CryptoTrack 🪙

A clean, intuitive, and highly responsive iOS application for tracking cryptocurrency prices.
Inspired by Apple's Human Interface Guidelines.

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

🔮 Future Roadmap
[ ] Refactor and expand SwiftUI Widgets.

[ ] Implement Combine or async/await for network calls.

[ ] Add application for Apple Watch. 

Designed and developed by **Kim Slabinskyi**

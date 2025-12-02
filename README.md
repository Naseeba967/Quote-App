# Daily Quote App 🌟

A beautiful and inspiring Flutter application that delivers daily quotes to keep you motivated. Features a clean UI, offline support, and the ability to save and share your favorite quotes.

## ✨ Features

- **Daily Inspiration**: Fetch random quotes from an external API.
- **Favorites Collection**: Save your favorite quotes to a local list for easy access.
- **Offline Support**: 
  - Caches the last viewed quote for offline viewing.
  - Persists your favorite quotes locally.
- **Share & Copy**: 
  - Share quotes directly to social media or other apps.
  - One-tap copy to clipboard.
- **Pull-to-Refresh**: Easily fetch a new quote with a pull gesture or button click.
- **Error Handling**: Graceful error states with retry options for network issues.
- **Clean UI**: Modern and minimalist design with smooth animations.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [http](https://pub.dev/packages/http)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Sharing**: [share_plus](https://pub.dev/packages/share_plus)

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
- An IDE (VS Code, Android Studio, or IntelliJ) with Flutter plugins.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/Naseeba967/Quote-App.git
    cd Quote-App
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the app:**

    ```bash
    flutter run
    ```

## 📂 Project Structure

```
lib/
├── constants/       # App-wide constants (colors, strings)
├── models/          # Data models (QuoteModel)
├── providers/       # State management (QuoteProvider)
├── screens/         # UI Screens (QuoteScreen, FavouriteScreen)
├── services/        # External services (API, Storage)
├── widgets/         # Reusable UI components
└── main.dart        # Entry point
```

## 🤝 Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

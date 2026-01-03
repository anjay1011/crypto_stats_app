# Crypto Stats

A modern cryptocurrency tracking app built with Flutter. Track real-time prices, view interactive charts, and stay updated with the crypto market.

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## Features

- **Real-time Data** - Live cryptocurrency prices from CoinGecko API
- **Interactive Charts** - Price charts with 24H and 7D views using FL Chart
- **Search & Filter** - Find coins with search and sorting options
- **Dark/Light Mode** - Seamless theme switching
- **Cross-Platform** - Runs on Android, iOS, Web, Windows, macOS, and Linux

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.9+ |
| State Management | Riverpod |
| API | CoinGecko |
| Charts | FL Chart |
| Styling | Google Fonts, Material 3 |

## Architecture

```
lib/
├── core/           # Theme and utilities
├── data/           # API, models, repositories
├── domain/         # Business logic
└── presentation/   # UI (screens, widgets, providers)
```

## Getting Started

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/crypto-stats-app.git
cd crypto-stats-app

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [CoinGecko API](https://www.coingecko.com/en/api) for cryptocurrency data
- [FL Chart](https://pub.dev/packages/fl_chart) for charts
- [Riverpod](https://riverpod.dev/) for state management

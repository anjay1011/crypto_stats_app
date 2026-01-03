# Contributing to Crypto Stats

First off, thank you for considering contributing to Crypto Stats! 🎉

## 🚀 How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title** describing the issue
- **Steps to reproduce** the behavior
- **Expected behavior** vs what actually happened
- **Screenshots** if applicable
- **Environment details** (Flutter version, device/OS)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- **Use case** - Why would this be useful?
- **Proposed solution** - How should it work?
- **Alternatives considered** - Other approaches you've thought about

### Pull Requests

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes with clear messages
4. **Push** to your branch
5. **Open** a Pull Request

#### Pull Request Guidelines

- Follow the existing code style
- Update documentation if needed
- Add tests for new features
- Ensure all tests pass (`flutter test`)
- Run `flutter analyze` for lint checks

## 💻 Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/crypto-stats-app.git
cd crypto-stats-app

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run the app
flutter run
```

## 📁 Project Structure

```
lib/
├── core/           # Core utilities and theme
├── data/           # Data layer (API, models, repositories)
├── domain/         # Business logic
└── presentation/   # UI layer (screens, widgets, providers)
```

## 🎨 Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Keep functions small and focused
- Add comments for complex logic

## 📝 Commit Messages

Use clear, descriptive commit messages:

- `feat: Add price alert feature`
- `fix: Resolve chart rendering issue`
- `docs: Update README installation guide`
- `refactor: Simplify crypto provider logic`
- `style: Format code with dart format`
- `test: Add unit tests for repository`

## ❓ Questions?

Feel free to open an issue for any questions or discussions!

---

Thank you for contributing! 🙌

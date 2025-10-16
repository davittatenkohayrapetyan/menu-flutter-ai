# Contributing to Menu Flutter AI

Thank you for your interest in contributing to Menu Flutter AI! This document provides guidelines and instructions for contributing to the project.

## Development Setup

1. Fork and clone the repository
2. Follow the [Quick Start Guide](QUICKSTART.md) to set up your development environment
3. Create a new branch for your feature or bug fix

## Code Style

### Flutter/Dart

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Run `flutter analyze` before committing to catch any issues
- Use `flutter format .` to format your code
- Prefer `const` constructors where possible
- Add comments for complex logic

### Node.js/JavaScript

- Use ES6+ features and modules
- Follow consistent naming conventions
- Add JSDoc comments for functions
- Handle errors properly with try-catch blocks

## Making Changes

### Flutter App

1. **Models**: When adding new models:
   - Use Freezed for immutable data classes
   - Add JSON serialization with json_serializable
   - Run code generation after changes:
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```

2. **Screens**: When adding new screens:
   - Use ConsumerWidget or ConsumerStatefulWidget for Riverpod
   - Add routes in `lib/router/router.dart`
   - Follow Material Design guidelines

3. **Services**: When adding new services:
   - Create a provider in `lib/providers/providers.dart`
   - Keep business logic separate from UI
   - Handle errors gracefully

### Backend Server

1. **API Endpoints**: When adding new endpoints:
   - Document the endpoint in the server README
   - Validate input data
   - Return consistent JSON responses
   - Handle errors with appropriate status codes

2. **OpenAI Integration**:
   - Be mindful of API costs
   - Add proper error handling for API failures
   - Consider rate limiting for production use

## Testing

### Flutter Tests

Run tests with:
```bash
flutter test
```

When adding tests:
- Write unit tests for business logic
- Write widget tests for UI components
- Mock external dependencies

### Server Tests

Add tests for new endpoints:
```bash
npm test  # If test script is configured
```

## Submitting Changes

1. **Commit Messages**:
   - Use clear, descriptive commit messages
   - Format: `[type] short description`
   - Types: feat, fix, docs, style, refactor, test, chore
   - Example: `feat: add ingredient extraction to parse-menu endpoint`

2. **Pull Requests**:
   - Create a PR from your feature branch
   - Provide a clear description of changes
   - Reference any related issues
   - Ensure all tests pass
   - Update documentation if needed

3. **Code Review**:
   - Address review comments promptly
   - Be open to feedback and suggestions
   - Keep discussions respectful and constructive

## Areas for Contribution

Here are some areas where contributions are welcome:

### Features
- Image caching and optimization
- Offline queue for API requests
- Dark mode support
- Multi-language support (i18n)
- Recipe suggestions based on menu items
- Dietary restriction filters
- Price tracking and comparisons
- Social sharing features

### Improvements
- Enhanced error handling
- Better loading states and animations
- Improved image processing
- Performance optimizations
- Accessibility improvements
- Better test coverage

### Documentation
- Additional examples
- Video tutorials
- API documentation
- Architecture diagrams

## Questions or Issues?

- Open an issue for bugs or feature requests
- Start a discussion for questions or ideas
- Be clear and provide examples when possible

## License

By contributing to Menu Flutter AI, you agree that your contributions will be licensed under the MIT License.

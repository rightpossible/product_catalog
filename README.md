# Product Catalog App

## Overview

This Flutter-based Product Catalog App allows users to browse, filter, and manage a list of products. It demonstrates key Flutter concepts, clean coding practices, and efficient state management.

## Features

- Browse a list of products
- View detailed product information
- Filter products by category or price range
- Add new products
- Edit existing products
- Delete products
- Offline data access and synchronization

## Technology Stack

- Flutter
- Bloc for state management
- Firebase Firestore for remote database
- SQLite (Drift) for local database
- GetIt for dependency injection
- Flutter Cache Manager for image caching

## Setup and Installation

1. Clone the repository:
   ```
   git clone https://github.com/rightpossible/product-catalog-app.git
   ```

2. Navigate to the project directory:
   ```
   cd product-catalog-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Set up Firebase:
   - Create a new Firebase project
   - Add your Android and iOS apps to the Firebase project
   - Download and place the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files in the appropriate directories
   - Enable Firestore in your Firebase project

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

The project follows a clean architecture approach with the following structure:

- `lib/`
  - `core/`: Core functionality and utilities
  - `features/`: Feature-based modules
    - `product/`: Product-related functionality
      - `data/`: Data layer (repositories, data sources)
      - `domain/`: Domain layer (entities, use cases)
      - `presentation/`: Presentation layer (UI, Bloc)
  - `layout/`: Shared layout components
  - `main.dart`: Entry point of the application

## State Management

This project uses the Bloc pattern for state management. The `ProductBloc` handles all product-related state changes and business logic. It's initialized in the `main.dart` file:

```
```
## Database Integration

The app uses both Firebase Firestore for remote storage and SQLite (via Drift) for local storage. This allows for offline access and synchronization when the device comes back online. The database integration is set up in the `init_dependencies.dart` file:

```
```
## Performance Optimizations

- Efficient list rendering using `ListView.builder`
- Image caching with Flutter Cache Manager
- Minimized widget rebuilds through proper use of const constructors and Bloc architecture

## Testing

Unit tests and widget tests are located in the `test/` directory. Run tests using:

```

## Design Decisions and Trade-offs

1. Bloc for State Management: Chosen for its clear separation of concerns and scalability. While it has a steeper learning curve compared to simpler solutions like Provider, it offers better testability and maintainability for larger projects.

2. Dual Database Approach: Using both Firestore and SQLite allows for offline functionality and quick local data access, at the cost of increased complexity in data synchronization logic.

3. Clean Architecture: The project structure follows clean architecture principles, which improves maintainability and testability but requires more initial setup and boilerplate code.

4. Firebase Integration: Offers quick backend setup and real-time capabilities, but may have higher costs for large-scale applications compared to a custom backend solution.

## Future Improvements

- Implement pagination for product list to handle large datasets more efficiently
- Add more comprehensive error handling and user feedback
- Enhance the UI with more animations and transitions
- Implement user authentication and personalized features

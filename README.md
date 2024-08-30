# Product Catalog App

## Overview

This Flutter application is a Product Catalog that allows users to browse, filter, add, edit, and delete products. It demonstrates proficiency in Flutter development, state management, database integration, and UI/UX design.

## Features

- Browse a list of products
- View detailed product information
- Filter products by category or price range
- Add new products
- Edit existing products
- Delete products
- Offline data access and synchronization

## Technology Stack

- **Framework**: Flutter
- **State Management**: Flutter Bloc
- **Database**: Cloud Firestore (with local caching)
- **Local Storage**: SQLite (via drift)
- **Dependency Injection**: GetIt
- **HTTP Client**: http package
- **Image Caching**: cached_network_image

## Project Structure

The project follows a feature-based structure, adhering to clean architecture principles:

```
lib/
  ├── core/
  │   ├── constants/
  │   ├── errors/
  │   ├── network/
  │   ├── usecases/
  │   └── utils/
  ├── features/
  │   ├── product/
  │   │   ├── data/
  │   │   │   ├── datasources/
  │   │   │   ├── models/
  │   │   │   └── repositories/
  │   │   ├── domain/
  │   │   │   ├── entities/
  │   │   │   ├── repositories/
  │   │   │   └── usecases/
  │   │   └── presentation/
  │   │       ├── bloc/
  │   │       ├── pages/
  │   │       └── widgets/
  │   └── other_features/
  │       └── ...
  ├── layout/
  │   └── pages/
  │       └── home_page.dart
  └── main.dart
```

- `core`: Contains core utilities, constants, and base classes.
- `data`: Implements data sources, models, and repositories.
- `domain`: Defines entities, repository interfaces, and use cases.
- `presentation`: Contains BLoCs, pages, and widgets for the UI.

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/rightpossible/product-catalog.git
```

2. Install dependencies:

```bash
cd product-catalog
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Dependencies

The app uses the following main dependencies:

- `flutter_bloc`: State management library.
- `cloud_firestore`: Cloud Firestore database for remote data storage.
- `drift`: SQLite database for local data persistence.
- `get_it`: Dependency injection library.
- `http`: HTTP client for making API requests.
- `cached_network_image`: Library for caching and displaying network images.

For a complete list of dependencies, refer to the `pubspec.yaml` file.

## Testing

The project includes unit tests and widget tests. To run the tests:

```bash
flutter test
```

## Future Improvements

- Implement user authentication and authorization.
- Add search functionality for products.
- Integrate with a payment gateway for product purchases.
- Implement push notifications for product updates and promotions.

Here are a few sections you could add to your README to provide more details about your project:

## Architecture

This project follows a Clean Architecture approach, which promotes separation of concerns and testability. The key principles followed are:

- **Separation of Concerns**: The code is divided into layers (data, domain, presentation), each with clear responsibilities. This makes the codebase more maintainable and easier to understand.

- **Dependency Inversion**: The domain layer is independent of the other layers and defines interfaces for data access and manipulation. This allows for easy substitution of implementations (e.g., switching databases).

- **Testability**: The use of dependency injection and the separation of the domain layer from external dependencies makes the code highly testable.

## State Management

This project uses the Flutter Bloc library for state management. Bloc (Business Logic Component) is a predictable state management library that helps implement the BLoC design pattern.

Key concepts in Bloc:

- **Bloc**: A component that converts a stream of incoming events into a stream of outgoing states. It manages the business logic of the application.

- **Event**: An input to a Bloc. It represents an action or occurrence in the application (e.g., user interactions, lifecycle events).

- **State**: An output of a Bloc. It represents a part of the application's state (e.g., loading, success, failure).

Bloc promotes a unidirectional data flow, which makes the application more predictable and easier to reason about.

## Design Decisions and Trade-offs

- **Local Data Persistence**: The application uses SQLite (via drift) for local data persistence. While other options like Hive were considered, SQLite was chosen for its robustness, query capabilities, and compatibility with existing SQL knowledge.

- **Image Caching**: The cached_network_image package is used for caching and displaying network images. This improves the application's performance by reducing network requests and loading times.

- **Dependency Injection**: The GetIt package is used for dependency injection. It provides a simple and flexible way to manage dependencies and promotes loose coupling between components.

- **Firestore for Remote Storage**: Cloud Firestore is used for remote data storage due to its real-time synchronization capabilities, scalability, and seamless integration with Flutter.

These design decisions were made considering factors such as performance, maintainability, scalability, and development efficiency. However, they may involve trade-offs like increased complexity or learning curve, which should be evaluated based on the project's specific requirements.
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

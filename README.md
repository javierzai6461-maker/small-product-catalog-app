# Product Catalog App

A small product catalog app built with Flutter, fetching data from the [DummyJSON API](https://dummyjson.com/products).

## Tech Stack
- **Framework**: Flutter
- **State Management**: Provider
- **Network**: HTTP package
- **Image Caching**: Cached Network Image

## Features
- Product List with pagination (infinite scrolling)
- Product Detail screen with image carousel and full description
- Server-side Search with debounce
- State handling (Loading, Success, Empty, Error with Retry)

## Bonus Features Implemented
- **Pull-to-Refresh**: Added `RefreshIndicator` on the product list screen to reload the catalog seamlessly.
- **Image Loading & Error Handling**: Utilized `cached_network_image` to show a clean `CircularProgressIndicator` during image load, and a custom fallback UI when image loading fails.
- **UI/UX Details**:
  - Implemented a pure Flutter splash screen with auto-navigation.
  - Added a responsive "Clear (X)" button in the search bar that dynamically appears only when there is text, allowing one-tap search reset.
  - Smooth infinite scrolling using robust `NotificationListener` detection.

## Architecture (MVC)
The codebase is structured into the following layers to separate concerns:
- `lib/model/`: Data definitions and entities (with null-safety handling)
- `lib/function/`: State management (`Provider` + `ChangeNotifier`) and business logic
- `lib/UI/`: UI components, screens, and widgets
- `lib/API/`: Network requests and endpoints
- `lib/constant/`: Reusable constants (shared `ViewState`, image paths)

## How to Run
This project uses **FVM (Flutter Version Management)** to ensure version consistency.
1. Run `fvm flutter pub get` to install dependencies.
2. Run `fvm flutter run` to launch the app on your device/emulator.

## AI Usage Declaration
AI was used to assist with the following tasks:
- **Project initialization**: Setting up the Flutter project structure.
- **Model scaffolding**: Generating the initial data model classes (`ProductModel`, `PaginatedResponse`).
- **README writing**: Helping structure and format this README for clarity.

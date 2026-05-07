# Smart Travel Companion

Smart Travel Companion is a Flutter travel app built for the SMD final assignment. It fetches travel-place data from an API, displays weather information, supports search and filters, stores offline cache data, manages favourites, shows Android notifications, and includes a map screen.

The project follows a simple clean architecture split:

- `lib/model/` contains data models, API clients, local cache, and repository implementation.
- `lib/domain/` contains repository contracts and use cases.
- `lib/presentation/` contains UI screens, widgets, theme, routing, controller, and services.

## Features

- Home screen with API places, search, category tabs, pull-to-refresh, and animated list.
- Detail screen with hero image, weather API data, expandable description, and map navigation.
- Search and filter screen with sort, show, and region filters.
- Favourites screen with persistent favourite places.
- Downloaded screen showing cached API data for offline use.
- Empty, retry, loading, and offline states.
- Light and dark themes.
- Android local notification when a new place is added to favourites.
- OpenStreetMap integration using `flutter_map`.
- Local placeholder image asset for all places, avoiding broken external image URLs.

## APIs Used

### Places API

`https://jsonplaceholder.typicode.com/photos`

Implemented in `lib/model/place_api.dart`.

The endpoint returns photo records. The app uses the IDs from the API and maps them into travel-place data such as title, country, region, description, latitude, and longitude in `lib/model/place.dart`.

The original API image URLs use `via.placeholder.com`, which can fail in Flutter web. To avoid broken image requests, the app uses the local asset:

`assets/images/travel_placeholder.png`

### Weather API

`https://api.open-meteo.com/v1/forecast`

Implemented in `lib/model/weather_api.dart`.

The detail screen sends the selected place latitude and longitude and shows:

- Temperature
- Wind speed
- Humidity
- Feels-like temperature

## Project Structure

```text
lib/
  main.dart
  domain/
    filter_places.dart
    get_places.dart
    get_weather.dart
    place_repository.dart
    toggle_favorite.dart
  model/
    local_cache.dart
    place.dart
    place_api.dart
    place_repository_impl.dart
    weather.dart
    weather_api.dart
  presentation/
    app.dart
    routes.dart
    controllers/
      travel_controller.dart
    screens/
      detail_screen.dart
      favorites_screen.dart
      filter_screen.dart
      home_screen.dart
      map_screen.dart
      offline_screen.dart
    services/
      notification_service.dart
    theme/
      app_theme.dart
    widgets/
      app_drawer.dart
      bottom_nav.dart
      category_selector.dart
      empty_state.dart
      favorite_button.dart
      filter_sheet.dart
      place_card.dart
      place_image.dart
      primary_button.dart
      retry_view.dart
      weather_card.dart
```

## Architecture Explanation

### Model Layer

The model layer handles data and external sources.

`place.dart` defines the `Place` model. It converts API photo data into travel locations and stores fixed location metadata such as country, region, latitude, and longitude.

`weather.dart` defines the `Weather` model returned by Open-Meteo.

`place_api.dart` fetches photo records from JSONPlaceholder.

`weather_api.dart` fetches current weather for a selected place.

`local_cache.dart` stores cached places and favourite IDs using `shared_preferences`.

`place_repository_impl.dart` connects API and cache logic. It tries cache first unless refresh is requested, fetches fresh API data, saves it locally, and falls back to cache if the network fails.

### Domain Layer

The domain layer contains business rules and app actions.

`place_repository.dart` defines the contract used by the app.

`get_places.dart` loads places.

`get_weather.dart` loads weather for a selected place.

`toggle_favorite.dart` adds or removes a place from favourites and persists the IDs.

`filter_places.dart` filters places by search query, category, region, and sort order.

### Presentation Layer

The presentation layer contains UI and state management.

`app.dart` creates the `MaterialApp`, applies themes, and configures named routes.

`routes.dart` defines app navigation for home, detail, favourites, filters, downloaded, and map screens. It also guards routes that require a `Place` argument.

`travel_controller.dart` is the main `ChangeNotifier` used with Provider. It stores places, favourites, filters, loading state, offline state, theme mode, and weather cache.

`app_theme.dart` defines the light and dark themes, primary purple color, card styling, chips, and form fields.

## Screens

### Home Screen

`home_screen.dart`

Shows the main list of places with:

- Drawer button
- Notification icon
- Search box
- Full-width category tabs
- Animated list of place cards
- Pull-to-refresh
- Bottom navigation
- Empty and retry states

### Detail Screen

`detail_screen.dart`

Shows:

- Hero image
- Back and favourite buttons
- Place title and country
- Description
- Weather card
- Expandable about section using `AnimatedSize`
- `View on Map` button

### Filter Screen

`filter_screen.dart`

Allows the user to filter places by:

- Search text
- Sort order
- All or Favourites
- Region

The filter UI reuses `CategorySelector` so repeated UI stays consistent.

### Favourites Screen

`favorites_screen.dart`

Shows all favourite places. If none exist, it displays an empty state.

### Downloaded Screen

`offline_screen.dart`

Shows cached API places loaded from the last successful API request. If there is no cached data, it asks the user to load places online first.

### Map Screen

`map_screen.dart`

Uses `flutter_map` and OpenStreetMap tiles. It centers the map on the selected place coordinates and shows a marker plus an info card.

## Important Widgets

`place_card.dart` displays large and compact place cards.

`place_image.dart` displays the local placeholder image asset and prevents broken network image errors.

`favorite_button.dart` toggles favourites and triggers Android notification when a place is added.

`weather_card.dart` shows current weather data.

`bottom_nav.dart` contains the bottom navigation and center add button.

`app_drawer.dart` contains drawer navigation, account info, and dark mode switch.

`empty_state.dart` and `retry_view.dart` provide reusable user feedback screens.

## Offline Support

When places load successfully from the API, they are saved in `shared_preferences`.

To test offline support:

1. Run the app with internet enabled.
2. Wait for places to load.
3. Disable internet or set Chrome DevTools Network to Offline.
4. Restart or refresh the app.
5. Cached places should still be available in Home and Downloaded.

If the app has never loaded API data before, it will show an empty or retry state.

## Favourites

Favourite IDs are saved locally using `shared_preferences`.

When the favourite button is clicked:

1. `FavoriteButton` calls `TravelController.toggleFavorite`.
2. `ToggleFavorite` updates the favourite ID set.
3. `PlaceRepositoryImpl` saves IDs through `LocalCache`.
4. The UI rebuilds with updated favourite state.
5. If the place was newly added, Android notification is shown.

## Android Notifications

Implemented in `lib/presentation/services/notification_service.dart`.

When a user adds a place to favourites, Android receives a notification:

- Title: `New location added to favourites`
- Body: `{location} has been added in the favourites`
- Image: local placeholder/location asset

The Android permission is declared in:

`android/app/src/main/AndroidManifest.xml`

Notifications only work on Android devices or emulators, not Chrome web.

## Map Integration

Map integration uses:

- `flutter_map`
- `latlong2`
- OpenStreetMap tiles

The map is opened from the detail screen using the selected `Place` object. Each place already contains latitude and longitude in `place.dart`.

## Animations Used

- `AnimatedList` on the home list.
- `AnimatedContainer` in place cards.
- `AnimatedOpacity` in empty states.
- `AnimatedSwitcher` for favourite icon and loading/weather states.
- `Hero` for place image transition.
- `AnimatedSize` for expandable description.

## Dependencies

Main dependencies from `pubspec.yaml`:

- `provider` for state management.
- `http` for REST API calls.
- `shared_preferences` for local cache and favourites.
- `flutter_local_notifications` for Android notifications.
- `flutter_map` and `latlong2` for map integration.

## Run The App

Install packages:

```bash
flutter pub get
```

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Android:

```bash
flutter run -d android
```

Android notifications require an Android device or emulator and notification permission approval.

## Validation

The project was validated with:

```bash
dart format lib
flutter analyze
```

If building Android on Windows fails with missing SDK, install Android Studio or set the `ANDROID_HOME` environment variable.

If a native asset hook fails because the project path contains spaces, move the project to a path without spaces, such as:

`C:\src\smart_travel_companion`

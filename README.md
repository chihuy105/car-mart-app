# Car-Mart

A Flutter app that opens `https://www.sgcarmart.com` in a WebView.

On launch, it also calls `https://jsonplaceholder.typicode.com/todos/1` through a shared Dio + Retrofit data layer and shows the returned `title` in a toast.

## Architecture

Feature-first clean architecture (`data` / `domain` / `presentation`).

**Retrofit** — `TodoApi` defines HTTP interface. Code-generated client. Single shared Dio instance per flavor.

**Bloc** — `TodoBloc` fetches todo on launch. `WebViewScreen` listens via `BlocListener`: success toasts `title`, failure shows error toast.

**Data flow** — API returns JSON → Retrofit deserializes to model → repository converts to `Entity` → bloc emits state → UI reacts.

## Requirements

- FVM
- Flutter 3.44.3

## Setup

```bash
fvm install
fvm flutter pub get
```

## Run

```bash
fvm flutter run --flavor development --target lib/main_development.dart
```

Other flavors:

```bash
fvm flutter run --flavor staging --target lib/main_staging.dart
fvm flutter run --flavor production --target lib/main_production.dart
```

## Build project

Run this after changing models, APIs, blocs, or dependency injection:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

## Test

```bash
fvm flutter test
```

## Project Structure

```text
lib/
├── app/
│   ├── app.dart            # root app + bloc providers
│   ├── exception/          # failures, exceptions, converters
│   ├── network/            # Dio client setup
│   ├── router/             # auto_route config + generated routes
│   └── theme/              # app theme
├── core/
│   ├── constants/          # app constants
│   ├── usecase/            # base use case types
│   └── utils/              # helpers like toast
├── di/                     # get_it + injectable setup
├── features/
│   ├── home/               # main screen / web view UI
│   └── todo/               # clean architecture todo feature
├── shared/
│   └── presentation/       # shared bloc status + reusable widgets
├── bootstrap.dart          # binding, DI, runApp
├── environment.dart        # flavor config
└── main_<flavor>.dart      # flavor entrypoints
```

## Screenshots

<img src="demo/img.png" width="300" /> <img src="demo/img_1.png" width="300" />

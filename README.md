# Frontend (Flutter) README

## Frontend Setup - Flutter

This part of the project is the **Flutter** mobile application. It connects to the backend via RESTful APIs and provides various features and a smooth user interface.

## Table of Contents

- [Flutter Setup](#flutter-setup)
  - [Install Flutter SDK](#install-flutter-sdk)
  - [Verify Installation](#verify-installation)
  - [Clone the Project](#clone-the-project)
  - [Install Dependencies](#install-dependencies)
  - [Setup Android Emulator or Physical Device](#setup-android-emulator-or-physical-device)
  - [Run the App](#run-the-app)
- [Project Structure](#project-structure)
- [Running the Application](#running-the-application)
- [Contributing](#contributing)
- [License](#license)

## Flutter Setup

### Install Flutter SDK
Download and install the Flutter SDK from the [official Flutter website](https://flutter.dev/docs/get-started/install).

### Verify Installation
Open a terminal and run the following command to verify your installation:
```bash
flutter doctor
```
This will check your installation and display any missing dependencies.

### Clone the Project
Clone the repository using your preferred Git client.

### Install Dependencies
Navigate to the Flutter project directory and run:
```bash
flutter pub get
```
This will install all necessary dependencies for the Flutter app.

### Setup Android Emulator or Physical Device
You can use either an Android Emulator or a physical device for testing. Make sure it's set up correctly.

### Run the App
To run the Flutter app, use the following command:
```bash
flutter run
```

## Project Structure

- **lib/**: Contains all Dart code, including models, screens, and the main app file.
- **pubspec.yaml**: Defines dependencies and configuration for the Flutter project.
- **android/**: Contains the Android-specific configuration for the Flutter app.

## Running the Application

### Running Flutter
Open the Flutter project in your preferred IDE (Android Studio, VS Code, etc.). Make sure an emulator or physical device is connected, then run the Flutter application:
```bash
flutter run
```
The Flutter app should now be running on your emulator or connected device.

## Contributing

We welcome contributions to this project! Please follow these steps if you would like to contribute:

1. Fork the repository.
2. Create a new branch (e.g., `git checkout -b feature-xyz`).
3. Make your changes.
4. Commit your changes (e.g., `git commit -am 'Add new feature'`).
5. Push your changes (e.g., `git push origin feature-xyz`).
6. Create a pull request.

## License

This project is licensed under the MIT License. See the LICENSE.md file for details.

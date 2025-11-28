# Flutter Gen Kit

A powerful CLI tool for supercharging your Flutter development workflow. Automate project setup, enforce architecture best practices, and generate boilerplate code with ease.

## Features

- **🚀 Instant Project Setup**: Initialize a new Flutter project with a production-ready structure in seconds.
- **🏗️ Flexible Architecture**: Choose between **Clean Architecture** (default) or **MVVM**.
- **⚡ State Management Support**: Built-in support for **Provider**, **Riverpod**, and **Bloc**.
- **🧩 Feature Generation**: Generate complete feature modules with a single command, tailored to your chosen architecture and state management.
- **🛠️ Best Practices**: Enforces separation of concerns, dependency injection, and clean code principles.
- **🌐 Localization Ready**: Automatically sets up `flutter_localizations` and `l10n.yaml`.

## Installation

Activate the package globally:

```bash
dart pub global activate flutter_gen_kit
```

## Usage

### Initialize a New Project

Create a new Flutter project with your preferred configuration:

```bash
flutter_gen_kit init --name <project_name>
```

You will be prompted to select:
1. **Architecture**: Clean Architecture or MVVM.
2. **State Management**: Provider, Riverpod, or Bloc.

The tool will:
- Create the Flutter project.
- Set up the folder structure (Core, Common, Features).
- Generate base files (Theme, Router, Network Client, etc.).
- Add necessary dependencies.
- Create a `gen_kit.yaml` configuration file.

### Generate a New Feature

Generate a new feature module within your project:

```bash
flutter_gen_kit feature <feature_name>
```

This command reads your `gen_kit.yaml` and generates the appropriate files and folders.

**Example (Clean Architecture + Riverpod):**
```
lib/features/my_feature/
├── data/
│   ├── datasources/
│   ├── dto/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── screens/
    └── viewmodels/
```

**Example (MVVM + Provider):**
```
lib/features/my_feature/
├── models/
├── views/
├── viewmodels/
└── repositories/
```

## Configuration

The `gen_kit.yaml` file in your project root stores your project's configuration:

```yaml
architecture: clean # or mvvm
state_management: riverpod # or provider, bloc
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

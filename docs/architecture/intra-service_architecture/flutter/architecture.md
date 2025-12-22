# 🏗️ Flutter Architecture of OmniMer EDU

This document outlines the **Clean Architecture** implementation in the `apps/mobile` Flutter project. The architecture is designed for **scalability, testability, and maintainability** by separating concerns into distinct layers: **Domain**, **Data**, and **Presentation**.

---

## 🏛️ High-Level Layer View

The project structure adheres to Clean Architecture principles:

- **`lib/domain`** (Inner Layer): The pure core of the application. Contains business logic, entities, and abstract repository definitions. It knows nothing about databases, APIs, or UI.
- **`lib/data`** (Middle Layer): The implementation layer. It handles data retrieval from APIs, local storage, mapping data to domain entities, and implementing the repositories defined in the domain layer.
- **`lib/presentation`** (Outer Layer): The UI and state management layer. It uses BLoC/Cubit to manage state and interacts with the domain layer via UseCases.

---

## 📂 1. Domain Layer (`lib/domain`)

This is the most stable layer and should change least frequently. It depends on NO other layers.

### 🧱 Entities (`lib/domain/entities`)

- **Purpose**: Represent the core business objects. These should be pure Dart classes (POJOs) extending `Equatable` for value comparison.
- **Structure**:
  - Simple fields representing the data.
  - **NO** JSON parsing logic (fromJson/toJson).
  - **NO** formatting or display logic.
- **Example**: `AuthUserEntity` containing `id`, `fullName`, `roleName`, etc.

```dart
// domain/entities/auth/auth_user_entity.dart
class AuthUserEntity extends Equatable {
  final String id;
  final String fullName;
  // ...

  const AuthUserEntity({required this.id, required this.fullName /*...*/});

  @override
  List<Object?> get props => [id, fullName /*...*/];
}
```

### 📝 Repositories (Interfaces) (`lib/domain/repositories`)

- **Purpose**: Define the _contract_ for data operations. The domain layer asks "What data do I need?" without caring "How do I get it?".
- **Return Types**: Always return `Future<Either<Failure, Type>>` to force error handling using functional programming principles (`fpdart` or custom `Either`).
- **Structure**: Abstract classes defining methods.

```dart
// domain/repositories/auth/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params);
  Future<Either<Failure, void>> logout();
}
```

### ⚙️ Use Cases (`lib/domain/usecases`)

- **Purpose**: Encapsulate a specific business rule or task (e.g., "Login User", "Get School Details").
- **Structure**:
  - Implement the `UseCase<Type, Params>` interface.
  - Single responsibility (one `call` or `execute` method).
  - Inject the abstract Repository.

```dart
// domain/usecases/auth/login_usecase.dart
class LoginUseCase implements UseCase<Either<Failure, AuthUserEntity>, LoginEntity> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(LoginEntity params) async {
    return await repository.login(params);
  }
}
```

---

## 💾 2. Data Layer (`lib/data`)

This layer implements the domain contracts and talks to the outside world.

### 📦 Models (`lib/data/models`)

- **Purpose**: Data Transfer Objects (DTOs) that extend Entities. They handle JSON serialization/deserialization.
- **Structure**:
  - Extend the corresponding Domain Entity.
  - Include `fromJson` factories and `toJson` methods.
  - Include `toEntity()` mapper methods (optional if extending directly).

```dart
// data/models/auth/auth_user_model.dart
class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({required String id, /*...*/}) : super(id: id, /*...*/);

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] ?? '',
      // ... safe parsing logic
    );
  }

  Map<String, dynamic> toJson() => { ... };
}
```

### 📡 Data Sources (`lib/data/datasources`)

- **Purpose**: Low-level data fetching. Divided into **Remote** (API) and **Local** (Cache/DB).
- **Remote**: Uses `ApiClient` (Dio wrapper) to call REST APIs. Returns `Models` (not Entities). Throws Exceptions (not Failures).
- **Local**: Uses `SecureStorage` or databases.

```dart
// data/datasources/remote/auth/auth_remote_data_source.dart
abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(LoginEntity params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  @override
  Future<AuthUserModel> login(LoginEntity params) async {
    final response = await client.post(Endpoints.login, data: ...);
    if (!response.success) throw ServerException(response.message);
    return AuthUserModel.fromJson(response.data);
  }
}
```

### 🛠️ Repositories (Implementation) (`lib/data/repositories`)

- **Purpose**: Implement the Domain Repository interface. Coordinate data sources and handle error catching.
- **Key Pattern**: Use a `safeApiCall` utility to wrap data source calls, catching Exceptions and converting them to `Failure` objects (Left side of Either).

```dart
// data/repositories/auth/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params) async {
    return safeApiCall(() async {
      final model = await remoteDataSource.login(params);
      return model; // Polymorphism: Model IS an Entity
    });
  }
}
```

---

## 🎨 3. Presentation Layer (`lib/presentation`)

Handles UI and user interaction.

### 🧠 State Management (BLoC)

- **Bloc**: Receives Events, processes them via UseCases, and emits States.
- **Event**: User actions (e.g., `AuthLoginRequested`).
- **State**: UI status (e.g., `AuthLoading`, `AuthAuthenticated`).
- **Dependency Injection**: UseCases are injected into BLoCs via `GetIt` (`sl()`).

```dart
// presentation/common/blocs/auth_bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(event.params);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    });
  }
}
```

### 📱 Screens & Widgets

- **Screens**: Top-level pages (e.g., `LoginScreen`). Use `BlocProvider` to scope logic if needed, or access global BLoCs.
- **Widgets**: Reusable UI components.
- **View**: `AppView` handles global navigation logic based on Authentication state.

---

## 🔗 Key Patterns & Utilities

1.  **Dependency Injection (`lib/services/locator.dart`)**:

    - Uses `get_it` to register:
      - **External**: Dio/ApiClient, SecureStorage.
      - **Data Sources**: Impls as singleton.
      - **Repositories**: Impls as singleton (bind interface to impl).
      - **Use Cases**: As lazy singletons/factory.
      - **BLoCs**: As factory (new instance per need).

2.  **Either Pattern**:

    - Strictly enforces error handling: `Left(Failure)` vs `Right(Success)`.
    - Prevents unhandled runtime exceptions in UI code.

3.  **ApiClient Wrapper**:

    - Centralized Dio configuration.
    - Automatic Token Interceptor (attach Bearer token).
    - Centralized Error Handling (convert 401/403/500 to Exceptions).
    - Token Refresh Logic (automatic retry on 401).

4.  **Routing (`lib/core/routing`)**:
    - Uses named routes (`RouteConfig`).
    - `AppView` handles the main `MaterialApp` and `onGenerateRoute`.
    - Supports dynamic routing and arguments.

---

## 🚀 Workflow for New Features

1.  **Define Entity** in Domain (`lib/domain/entities`).
2.  **Define Repository Interface** in Domain (`lib/domain/repositories`).
3.  ** create Use Case** in Domain (`lib/domain/usecases`).
4.  **Create Model** in Data (`lib/data/models`) implementing Entity & `fromJson`.
5.  **Add/Update Data Source** in Data (`lib/data/datasources`).
6.  **Implement Repository** in Data (`lib/data/repositories`), connecting Source to Domain.
7.  **Register DI** in `locator.dart`.
8.  **Create BLoC** in Presentation, injecting UseCase.
9.  **Build UI** connecting to BLoC.

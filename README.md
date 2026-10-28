# Work Orders EPAA 📱

Aplicación móvil y web para gestión de órdenes de trabajo, desarrollada con Flutter bajo principios de Clean Architecture, BLoC/Cubit, Injectable y AutoRoute.

---

## 📑 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Ambientes y Flavors](#ambientes-y-flavors)
3. [Comandos Fundamentales](#comandos-fundamentales)
   - [Instalación y Dependencias](#1-instalación-y-dependencias)
   - [Generación de Código](#2-generación-de-código-build_runner)
   - [Ejecución en Desarrollo (Run)](#3-ejecución-en-desarrollo-run)
   - [Compilación y Builds (APK / Bundle)](#4-compilación-y-builds-apk--bundle)
   - [Calidad de Código y Pruebas](#5-calidad-de-código-y-pruebas)
   - [Generadores Mason (Bricks)](#6-generadores-mason-bricks)
   - [Iconos de la Aplicación](#7-iconos-de-la-aplicación)

---

## Requisitos Previos

- **Flutter SDK**: `>=3.10.0 <4.0.0`
- **Java / JDK**: 17
- **Archivo de Entorno (`.env`)**: Debe existir en la raíz del proyecto con las claves necesarias (ej. `GOOGLE_MAPS_API_KEY`).
- **Firma Release (`android/key.properties`)**: Requerido para construir compilaciones en release firmadas.

---

## Ambientes y Flavors

El proyecto maneja 3 sabores (*flavors*) configurados en Android (`build.gradle.kts`):

| Ambiente | Flavor Gradle / Flutter | Entrypoint (Target) | Sufijo de ID / Package |
| :--- | :--- | :--- | :--- |
| **Desarrollo** | `development` | `lib/main_dev.dart` | `.dev` |
| **Staging** | `staging` | `lib/main_stg.dart` | `.stg` |
| **Producción** | `production` | `lib/main.dart` | *(ninguno)* |

> [!WARNING]
> Para el sabor de producción siempre usa `--flavor production` (no uses `prod`, de lo contrario Flutter no encontrará el APK generado).

---

## Comandos Fundamentales

### 1. Instalación y Dependencias

- **Descargar paquetes:**
  ```bash
  flutter pub get
  ```

- **Limpiar artefactos y caché de compilación:**
  ```bash
  flutter clean
  flutter pub get
  ```

> [!NOTE]
> `flutter pub get` genera el archivo de registro de plugins en modo depuración. Si vas a generar un build de producción inmediatamente después, consulta la nota en la sección de [Compilación y Builds](#4-compilación-y-builds-apk--bundle).

---

### 2. Generación de Código (`build_runner`)

Esencial para generar rutas (`auto_route`), inyección de dependencias (`injectable`) y serialización JSON:

- **Generar código una sola vez (eliminando conflictos):**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

- **Modo observador (reconstruye automáticamente al guardar cambios):**
  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```

---

### 3. Ejecución en Desarrollo (`run`)

#### En Dispositivo / Emulador (Android / iOS):
- **Desarrollo:**
  ```bash
  flutter run --flavor development --target lib/main_dev.dart
  ```
- **Staging:**
  ```bash
  flutter run --flavor staging --target lib/main_stg.dart
  ```
- **Producción:**
  ```bash
  flutter run --flavor production --target lib/main.dart
  ```

#### En Web (Chrome):
- **Ejecución estándar:**
  ```bash
  flutter run -d chrome --target lib/main_dev.dart
  ```
- **Sin restricciones de CORS (útil para pruebas de APIs locales):**
  ```bash
  flutter run -d chrome --target lib/main_dev.dart --web-browser-flag="--disable-web-security"
  ```

---

### 4. Compilación y Builds (APK / Bundle)

#### Producción (Production)
- **Generar APK Release:**
  ```bash
  flutter build apk --release --flavor production --target lib/main.dart
  ```
- **Generar Android App Bundle (AAB para Google Play):**
  ```bash
  flutter build appbundle --release --flavor production --target lib/main.dart
  ```

#### Staging
- **Generar APK Release:**
  ```bash
  flutter build apk --release --flavor staging --target lib/main_stg.dart
  ```
- **Generar Android App Bundle (AAB):**
  ```bash
  flutter build appbundle --release --flavor staging --target lib/main_stg.dart
  ```

#### Desarrollo (Development)
- **Generar APK Debug:**
  ```bash
  flutter build apk --debug --flavor development --target lib/main_dev.dart
  ```
- **Generar APK Release (Dev):**
  ```bash
  flutter build apk --release --flavor development --target lib/main_dev.dart
  ```

> [!IMPORTANT]
> **Solución a error de compilación Release (`integration_test` / `patrol` not found):**  
> Si al compilar en release obtienes un error del tipo:  
> `error: package dev.flutter.plugins.integration_test does not exist` o `package pl.leancode.patrol does not exist` en `GeneratedPluginRegistrant.java`, se debe a que `flutter pub get` generó el registro de plugins en modo debug (incluyendo dependencias de test que Gradle omite en release).  
> 
> Para solucionarlo, elimina el archivo generado antes de compilar o fuerza la configuración de release:
> ```bash
> # Opción 1: Eliminar el registrador previo y compilar
> rm -f android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
> flutter build apk --release --flavor production --target lib/main.dart
> 
> # Opción 2: Sincronizar configuración en release y compilar
> flutter build apk --config-only --release --flavor production --target lib/main.dart
> flutter build apk --release --flavor production --target lib/main.dart
> ```

> [!TIP]
> Los APKs generados se ubican en:
> `build/app/outputs/flutter-apk/` y `build/app/outputs/apk/<flavor>/<buildType>/`

---

### 5. Calidad de Código y Pruebas

- **Análisis estático de código:**
  ```bash
  flutter analyze
  ```

- **Ejecutar pruebas unitarias y de widgets:**
  ```bash
  flutter test
  ```

- **Ejecutar pruebas con reporte de cobertura:**
  ```bash
  flutter test --coverage
  ```

- **Instalar CLI de Patrol (si no está instalado):**
  ```bash
  dart pub global activate patrol_cli
  ```

- **Ejecutar pruebas de integración con Patrol:**
  ```bash
  patrol test --target patrol_test/login_test.dart --flavor development
  ```

---

### 6. Generadores Mason (Bricks)

Si utilizas plantillas para crear módulos y pantallas con la arquitectura del proyecto:

- **Instalar / Sincronizar Bricks locales:**
  ```bash
  mason get
  ```

- **Generar un nuevo Feature Cubit:**
  ```bash
  mason make cubit_feature -c config.json
  # o de forma interactiva:
  mason make cubit_feature
  ```

- **Generar una nueva Página Cubit:**
  ```bash
  mason make cubit_page -c config.json
  # o de forma interactiva:
  mason make cubit_page
  ```

---

### 7. Iconos de la Aplicación

Para regenerar los iconos de la app a partir de `assets/images/work_order.png`:
```bash
dart run flutter_launcher_icons
```

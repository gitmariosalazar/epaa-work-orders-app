import java.util.Properties
import java.io.FileInputStream
import java.io.IOException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cleanArchitecture"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID[](https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.cleanArchitecture"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
    }

 // === SIGNING CONFIGS PARA RELEASE (CORREGIDO) ===
signingConfigs {
    create("release") {
        val keystoreProperties = Properties()
        val keystorePropertiesFile = rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            keystoreProperties.load(FileInputStream(keystorePropertiesFile))
        } else {
            throw GradleException("key.properties not found at ${keystorePropertiesFile.path}")
        }

        // Usa getProperty y maneja nulls
        keyAlias = keystoreProperties.getProperty("keyAlias")
            ?: throw GradleException("keyAlias missing in key.properties")
        keyPassword = keystoreProperties.getProperty("keyPassword")
            ?: throw GradleException("keyPassword missing in key.properties")
        storePassword = keystoreProperties.getProperty("storePassword")
            ?: throw GradleException("storePassword missing in key.properties")

        val storeFilePath = keystoreProperties.getProperty("storeFile")
            ?: throw GradleException("storeFile missing in key.properties")
        storeFile = file(storeFilePath)
    }
}

// Aplica al release
buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}

    flavorDimensions += "default"

    productFlavors {
        create("production") {
            dimension = "default"
            resValue("string", "app_name", "Órdenes de Trabajo")
            resValue("string", "google_maps_api_key", googleMapsApiKey())
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".stg"
            versionNameSuffix = ".stg"
            resValue("string", "app_name", "Órdenes de Trabajo STG")
            resValue("string", "google_maps_api_key", googleMapsApiKey())
        }
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            versionNameSuffix = ".dev"
            resValue("string", "app_name", "Órdenes de Trabajo DEV")
            resValue("string", "google_maps_api_key", googleMapsApiKey())
        }
    }

    testOptions {
        execution = "ANDROIDX_TEST_ORCHESTRATOR"
    }
}

fun googleMapsApiKey(): String {
    val envFile = project.rootProject.file("../.env")

    if (!envFile.exists()) {
        println("❌ Warning: Archivo .env no encontrado en \${envFile.absolutePath}")
        return "MISSING_KEY"
    }

    return try {
        val props = Properties()
        envFile.inputStream().use { props.load(it) }
        val key = props.getProperty("GOOGLE_MAPS_API_KEY")
        if (key.isNullOrBlank()) {
            println("❌ Warning: GOOGLE_MAPS_API_KEY vacía o no encontrada en .env")
            "MISSING_KEY"
        } else {
            key.trim()
        }
    } catch (e: Exception) {
        println("❌ Error al leer .env: \${e.message}")
        "MISSING_KEY"
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    androidTestUtil("androidx.test:orchestrator:1.5.1")
    implementation("com.google.android.gms:play-services-location:21.3.0")
    implementation("com.google.android.gms:play-services-maps:19.2.0")
}
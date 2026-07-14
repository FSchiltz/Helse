import com.android.build.gradle.internal.api.ApkVariantOutputImpl

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.fschiltz.helse"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.fschiltz.helse"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (System.getenv("CI") == "true") {
            create("release") {
                keyAlias = System.getenv("KEY_ALIAS")
                keyPassword = System.getenv("KEY_PASSWORD")
                storeFile = System.getenv("KEYSTORE_PATH")?.let { file(it) }
                storePassword = System.getenv("KEYSTORE_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (System.getenv("CI") == "true") {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Enable code shrinking to reduce APK size
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }

    // Strip Google proprietary block from APK
    dependenciesInfo {
            includeInApk = false
            includeInBundle = false
    }
}

// --- F-Droid ABI Split Version Code Generation ---
val abiCodes = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 3)

android.applicationVariants.configureEach {
    val variant = this
    variant.outputs.forEach { output ->
        val abiVersionCode = abiCodes[output.filters.find { it.filterType == "ABI" }?.identifier]
        if (abiVersionCode != null) {
            (output as ApkVariantOutputImpl).versionCodeOverride = variant.versionCode * 10 + abiVersionCode
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

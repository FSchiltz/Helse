plugins{
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    namespace("com.fschiltz.helse")
    compileSdk(flutter.compileSdkVersion)
    ndkVersion = "28.2.13676358"

    compileOptions {
        coreLibraryDesugaringEnabled =true
        sourceCompatibility= JavaVersion.VERSION_17
        targetCompatibility =JavaVersion.VERSION_17
    }

    kotlinOptions{
        jvmTarget = '17'
    }

    sourceSets{
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig{
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.fschiltz.helse"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdkVersion 28
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }


    signingConfigs{
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
            signingConfig = (System.getenv("CI") == "true")? signingConfigs.getByName("release"): signingConfigs.getByName("debug")
            

            // Enable code shrinking to reduce APK size
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }

    dependenciesInfo {
        includeInApk = false
        includeInBundle = false
    }
}

flutter {
    source('../..')
}

dependencies {
    coreLibraryDesugaring('com.android.tools:desugar_jdk_libs:2.1.4')
}

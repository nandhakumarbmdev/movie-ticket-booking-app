plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter Gradle plugin (must be AFTER android + kotlin)
    id("dev.flutter.flutter-gradle-plugin")

    // Google Services plugin (Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.movie_ticket_booking"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.movie_ticket_booking"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use debug signing for now (fine for development)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))

    // Firebase Analytics (required base)
    implementation("com.google.firebase:firebase-analytics")

    // 👉 Add more Firebase SDKs here if needed
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-messaging")
}

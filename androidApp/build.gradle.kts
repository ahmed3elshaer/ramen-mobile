plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    namespace = "com.ahmed3elshaer.ramen.android"
    compileSdk = (findProperty("android.compileSdk") as String).toInt()
    defaultConfig {
        applicationId = "com.ahmed3elshaer.ramen.android"
        minSdk = (findProperty("android.minSdk") as String).toInt()
        targetSdk = (findProperty("android.targetSdk") as String).toInt()
        versionCode = 1
        versionName = "1.0"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = libs.versions.androidx.compose.compiler.get()
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    implementation(project(":components:datasource"))
    implementation(project(":components:presentation"))
    implementation(project(":shared"))
    //desugar utils
    coreLibraryDesugaring(libs.desugar.jdk.libs)
    //Compose
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.tooling)
    implementation(libs.androidx.compose.foundation)
    implementation(libs.androidx.compose.material)
    //Compose Utils
    implementation(libs.coil.compose)
    implementation(libs.activity.compose)
    implementation(libs.accompanist.swiperefresh)
    //Coroutines
    implementation(libs.kotlinx.coroutines.core)
    implementation(libs.kotlinx.coroutines.android)
    //DI
    implementation(libs.koin.core)
    implementation(libs.koin.android)
    implementation(libs.koin.compose)
    //Navigation
    implementation(libs.voyager.navigator)
}
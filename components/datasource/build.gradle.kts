
plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.pluginKotlinSerialization)
    alias(libs.plugins.androidLibrary)
}


kotlin {
    androidTarget()
    iosX64()
    iosArm64()
    iosSimulatorArm64()

    sourceSets {
        val commonMain by getting {
            dependencies {
                //Network
                implementation(libs.ktor.core)
                implementation(libs.ktor.logging)
                implementation(libs.ktor.content.negotiation)
                implementation(libs.ktor.json)
                //Coroutines
                implementation(libs.kotlinx.coroutines.core)
                //Logger
                implementation(libs.napier)
                //JSON
                implementation(libs.kotlinx.serialization.json)
                //Key-Value storage
                implementation(libs.multiplatform.settings)
                // DI
                api(libs.koin.core)
            }
        }
        val androidMain by getting {
            dependencies {
                //Network
                implementation(libs.ktor.client.okhttp)
            }
        }
        val iosMain by creating {
            dependencies {
                //Network
                implementation(libs.ktor.client.ios)
            }
        }
    }
}

// Core
android {
    namespace = "com.ramen.datasource"
    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    compileSdk = (findProperty("android.compileSdk") as String).toInt()

    defaultConfig {
        minSdk = (findProperty("android.minSdk") as String).toInt()
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
      
    }
    dependencies {
        coreLibraryDesugaring(libs.desugar.jdk.libs)
    }
}
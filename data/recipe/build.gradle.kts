
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
                implementation(project(":domain:recipe"))
                //Network
                implementation(libs.ktor.core)
                implementation(libs.ktor.logging)
                //Logger
                implementation(libs.napier)
                //Coroutines
                implementation(libs.kotlinx.coroutines.core)
                //JSON
                implementation(libs.kotlinx.serialization.json)

                //Key-Value storage
                implementation(project(":components:datasource"))
                // DI
                api(libs.koin.core)
            }
        }
        val androidMain by getting
        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting
        val iosMain by creating {
           
        }
    }
}

// Ingredient
android {
    namespace = "com.ramen.recipe.data"
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
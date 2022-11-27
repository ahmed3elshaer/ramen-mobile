plugins {
    kotlin("multiplatform")
    kotlin("plugin.serialization")
    id("com.android.library")

}

kotlin {
    android()
    iosX64()
    iosArm64()
    iosSimulatorArm64()

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(project(":domain:recipe"))
                implementation(project(":data:ingredients"))
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
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)
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
        targetSdk = (findProperty("android.targetSdk") as String).toInt()
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    dependencies {
        coreLibraryDesugaring(libs.desugar.jdk.libs)
    }
}
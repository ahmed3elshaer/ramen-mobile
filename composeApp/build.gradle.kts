import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidApplication)
    alias(libs.plugins.compose.multiplatform)
    alias(libs.plugins.compose.compiler)
    alias(libs.plugins.composeHotReload)
}


kotlin {
    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }
    
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "ComposeApp"
            isStatic = true
        }
    }
    
    sourceSets {
        commonMain.dependencies {
            implementation(compose.runtime)
            implementation(compose.foundation)
            implementation(compose.material3)
            implementation(compose.materialIconsExtended)
            implementation(compose.ui)
            implementation(compose.components.resources)
            implementation(compose.components.uiToolingPreview)
            // Navigation
            implementation(libs.voyager.navigator)
            // DI
            implementation("io.insert-koin:koin-compose:4.0.3")
            implementation("io.insert-koin:koin-compose-viewmodel:4.0.3")
            implementation("io.insert-koin:koin-compose-viewmodel-navigation:4.0.3")
            // Coroutines
            implementation(libs.kotlinx.coroutines.core)
            // Logger
            implementation(libs.napier)
            implementation("io.coil-kt.coil3:coil-compose:3.2.0")
            implementation("io.coil-kt.coil3:coil-network-ktor3:3.2.0")
            implementation(libs.androidx.lifecycle.viewmodel)
            implementation(libs.androidx.lifecycle.runtimeCompose)
            // Shared modules
            implementation(project(":shared"))
            implementation(project(":presentation-recipe"))
        }
        
        androidMain.dependencies {
            implementation(compose.preview)
            implementation(libs.activity.compose)
            implementation(libs.kotlinx.coroutines.android)
        }
        
        iosMain.dependencies {
        }
    }
}

android {
    namespace = "com.ramen.ui"
    compileSdk = (findProperty("android.compileSdk") as String).toInt()

    defaultConfig {
        minSdk = (findProperty("android.minSdk") as String).toInt()
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }

    
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    buildFeatures {
        compose = true
    }
}

dependencies {
    coreLibraryDesugaring(libs.desugar.jdk.libs.v203)
    debugImplementation(compose.uiTooling)
} 
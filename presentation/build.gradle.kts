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
				implementation(project(":components:presentation"))
				implementation(project(":domain"))
				//kotlinx
				implementation(libs.kotlinx.coroutines.core)
				implementation(libs.kotlinx.datetime)
				//DI
				implementation(libs.koin.core)
				//Logger
				implementation(libs.napier)
				implementation(libs.precompose.viewmodel)

			}

		}
		val iosX64Main by getting
		val iosArm64Main by getting
		val iosSimulatorArm64Main by getting
		val iosMain by creating {

		}
	}
}

// Ingredients
android {
	namespace = "com.ramen.presentation.recipe"
	sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
	compileSdk = libs.versions.android.targetSdk.get().toInt()
	defaultConfig {
		minSdk = libs.versions.android.minSdk.get().toInt()
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
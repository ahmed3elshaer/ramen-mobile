plugins {
	alias(libs.plugins.kotlinMultiplatform)
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
				implementation(libs.kotlinx.coroutines.core)
				implementation(libs.koin.core)
				implementation(libs.kotlinx.datetime)
				implementation(projects.components.presentation)
			}
		}
		val iosX64Main by getting
		val iosArm64Main by getting
		val iosSimulatorArm64Main by getting
		val iosMain by creating {

		}
	}
}

android {
	namespace = "com.ramen.recipe.domain"
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
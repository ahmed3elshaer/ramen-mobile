plugins {
	alias(libs.plugins.kotlinMultiplatform)
	alias(libs.plugins.androidLibrary)
}

version = "1.1.0"


kotlin {
	androidTarget()
	listOf(
			iosX64(),
			iosArm64(),
			iosSimulatorArm64()
	).forEach { iosTarget ->
		iosTarget.binaries.framework {
			baseName = "Shared"
			isStatic = true
			export(project(":components:datasource"))
			export(project(":components:presentation"))
			//recipe
			export(project(":data"))
			export(project(":domain"))
			export(project(":presentation"))
		}
	}

	sourceSets {
		val commonMain by getting {
			dependencies {
				api(project(":components:datasource"))
				api(project(":components:presentation"))

				//recipe
				api(project(":data"))
				api(project(":domain"))
				api(project(":presentation"))


			}
		}
	}
}

android {
	namespace = "com.ramen.shared"
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
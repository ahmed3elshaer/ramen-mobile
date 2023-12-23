plugins {
	alias(libs.plugins.kotlinMultiplatform)
	alias(libs.plugins.androidLibrary)
}

version = "1.1.0"


kotlin {
	androidTarget {
		compilations.all {
			kotlinOptions {
				jvmTarget = "17"
			}
		}
	}

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
			export(project(":data:recipe"))
			export(project(":domain:recipe"))
			export(project(":presentation:recipe"))
		}
	}

	sourceSets {
		val commonMain by getting {
			dependencies {
				api(project(":components:datasource"))
				api(project(":components:presentation"))

				//recipe
				api(project(":data:recipe"))
				api(project(":domain:recipe"))
				api(project(":presentation:recipe"))


			}
		}
	}
}

android {
	namespace = "com.ramen.shared"
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
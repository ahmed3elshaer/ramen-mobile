rootProject.name = "ramen"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
	repositories {
		maven("https://maven.pkg.jetbrains.space/public/p/compose/dev")
		mavenCentral()
		google()
		gradlePluginPortal()
	}
}

dependencyResolutionManagement {
	repositories {
		mavenCentral()
		google()
		gradlePluginPortal()
		maven("https://maven.pkg.jetbrains.space/public/p/compose/dev")

	}
}


include(":composeApp")

include(":shared")
include(":components:presentation")
include(":components:datasource")

include(":domain", ":data")

include(":presentation")


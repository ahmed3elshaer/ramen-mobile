rootProject.name = "ramen"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
	repositories {
		google()
		gradlePluginPortal()
		mavenCentral()
	}
}

dependencyResolutionManagement {
	repositories {
		google()
		gradlePluginPortal()
		mavenCentral()
	}
}


include(":androidApp")

include(":shared")
include(":components:presentation")
include(":components:datasource")

include(":domain-recipe")
include(":data-recipe")

include(":presentation-recipe")


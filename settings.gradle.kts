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
        mavenCentral()
    }
}

rootProject.name = "Ramen"
include(":androidApp")
include(":shared")
include(":domain:recipe")

enableFeaturePreview("VERSION_CATALOGS")
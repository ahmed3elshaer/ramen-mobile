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
include(":components:datasource")
include(":components:presentation")
include(":shared")

include(":domain:recipe")
include(":domain:ingredients")

include(":data:ingredients")

enableFeaturePreview("VERSION_CATALOGS")
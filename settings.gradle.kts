rootProject.name = "Ramen"

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

include(":androidApp")
include(":shared")
include(":components:presentation")
include(":components:datasource")

include(":domain:recipe")
include(":domain:ingredients")

include(":data:ingredients")
include(":data:recipe")

enableFeaturePreview("VERSION_CATALOGS")
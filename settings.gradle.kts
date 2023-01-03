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
//components
include(":shared")
include(":components:presentation")
include(":components:datasource")
//domain
include(":domain:recipe", ":data:recipe")
include(":domain:ingredients", ":data:ingredients")
//store
include(":presentation:monitor")
include(":presentation:store")
include(":presentation:recipe")
include(":presentation:recipeinfo")

enableFeaturePreview("VERSION_CATALOGS")
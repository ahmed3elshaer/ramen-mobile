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
include(":domain:recipe")
include(":domain:ingredients")
//data
include(":data:ingredients")
include(":data:recipe")
//store
include(":presentation:monitor")
include(":presentation:store")
include(":presentation:recipe")

enableFeaturePreview("VERSION_CATALOGS")
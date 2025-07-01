plugins {
    alias(libs.plugins.androidApplication) apply false
    alias(libs.plugins.androidLibrary) apply false
    alias(libs.plugins.kotlinJvm) apply false
    alias(libs.plugins.pluginKotlinSerialization) apply false
    alias(libs.plugins.kotlinMultiplatform) apply false
    alias(libs.plugins.compose.compiler) apply false
    alias(libs.plugins.compose.multiplatform) apply false
}
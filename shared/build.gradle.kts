import org.jetbrains.kotlin.gradle.plugin.mpp.Framework.BitcodeEmbeddingMode.BITCODE

plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    kotlin("plugin.serialization")
    id("com.android.library")

}

version = "1.0"


kotlin {
    android()
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = "shared"
            export(project(":components:datasource"))
            export(project(":components:presentation"))
            //presentation
            export(project(":presentation:monitor"))

            //ingredients
            export(project(":data:ingredients"))
            export(project(":domain:ingredients"))

            //recipe
            export(project(":data:recipe"))
            export(project(":domain:recipe"))
        }
    }

    cocoapods {
        summary = "Some description for the Shared Module"
        homepage = "Link to the Shared Module homepage"
        version = "1.0"
        ios.deploymentTarget = "14.1"
        podfile = project.file("../iosApp/Podfile")
        framework {
            baseName = "shared"
            isStatic = false
            export(project(":components:datasource"))
            export(project(":components:presentation"))
            //presentation
            export(project(":presentation:monitor"))

            //ingredients
            export(project(":data:ingredients"))
            export(project(":domain:ingredients"))

            //recipe
            export(project(":data:recipe"))
            export(project(":domain:recipe"))
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                api(project(":components:presentation"))
                //presentation
                api(project(":presentation:monitor"))

                //ingredients
                api(project(":data:ingredients"))
                api(project(":domain:ingredients"))

                //recipe
                api(project(":data:recipe"))
                api(project(":domain:recipe"))


            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test"))
            }
        }
        val androidMain by getting
        val androidTest by getting
        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting
        val iosMain by creating {
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)


        }
        val iosX64Test by getting
        val iosArm64Test by getting
        val iosSimulatorArm64Test by getting
        val iosTest by creating {
            dependsOn(commonTest)
            iosX64Test.dependsOn(this)
            iosArm64Test.dependsOn(this)
            iosSimulatorArm64Test.dependsOn(this)
        }
    }
}

android {
    namespace = "com.ramen.shared"
    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    compileSdk = (findProperty("android.compileSdk") as String).toInt()

    defaultConfig {
        minSdk = (findProperty("android.minSdk") as String).toInt()
        targetSdk = (findProperty("android.targetSdk") as String).toInt()
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    dependencies {
        coreLibraryDesugaring(libs.desugar.jdk.libs)
    }
}
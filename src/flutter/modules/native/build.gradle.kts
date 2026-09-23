plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    id("kotlin-parcelize")
    kotlin("plugin.serialization") version "2.1.20"
}

val abiFilter = listOf("arm64-v8a", "x86_64")

@Suppress("UnstableApiUsage")
android {
    namespace = "org.citra.citra_emu.emucore"

    compileSdkVersion = "android-37"
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        prefab = true
    }

    sourceSets {
        named("main") {
            kotlin.srcDir("src/main/kotlin")
        }
    }

    defaultConfig {
        minSdk = 28

        ndk {
            @Suppress("ChromeOsAbiSupport")
            abiFilters += abiFilter
        }

        externalNativeBuild {
            cmake {
                arguments(
                    "-DENABLE_QT=0",
                    "-DENABLE_SDL2=0",
                    "-DANDROID_ARM_NEON=true",
                    "-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON",
                    "-DANDROID_STL=c++_shared"
                )
            }
        }
    }

    buildTypes {
        debug {
            externalNativeBuild {
                cmake {
                    arguments("-DCMAKE_BUILD_TYPE=RelWithDebInfo")
                }
            }
        }
    }

    externalNativeBuild {
        cmake {
            version = "3.22.1"
            path = file("../../../../CMakeLists.txt")
        }
    }
}

dependencies {
    implementation("androidx.activity:activity-ktx:1.9.2")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.documentfile:documentfile:1.0.1")
    implementation("androidx.drawerlayout:drawerlayout:1.2.0")
    implementation("androidx.fragment:fragment-ktx:1.8.3")
    implementation("androidx.games:games-controller:2.0.2")
    implementation("androidx.preference:preference-ktx:1.2.1")
    implementation("com.google.android.material:material:1.9.0")
    implementation("com.squareup.okio:okio:3.9.0")
    implementation("info.debatty:java-string-similarity:2.0.0")
    implementation("org.ini4j:ini4j:0.5.4")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.2")
    implementation("androidx.work:work-runtime:2.9.1")
}

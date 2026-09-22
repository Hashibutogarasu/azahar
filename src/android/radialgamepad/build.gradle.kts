// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

/**
 * Builds Swordfish90/RadialGamePad's `library` module (the `externals/radial-gamepad` git
 * submodule) against this project's own Android/Kotlin toolchain, instead of applying that
 * submodule's own build.gradle, which targets `kotlin-android-extensions` — a plugin removed
 * from modern Kotlin Gradle Plugin releases. Only the submodule's Kotlin/Java sources are
 * reused here; this module supplies its own manifest and dependency versions.
 */
plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.swordfish.radialgamepad.library"
    compileSdk = 35

    defaultConfig {
        minSdk = 28
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        named("main") {
            java.srcDir("../../externals/radial-gamepad/library/src/main/java")
        }
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.customview:customview:1.1.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
}

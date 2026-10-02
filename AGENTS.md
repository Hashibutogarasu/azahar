# AGENTS.md

Guidance for agents working in this repository.

## Local environment file (`.env.sh`)

Keep the machine-specific paths in `.env.sh` at the repository root and `source` it before running any build command. The file is listed in `.gitignore` and must never be committed.

It has to make the following tools available:

| Variable | Purpose |
| --- | --- |
| `FLUTTER_ROOT` | Flutter SDK. Use the version pinned in `.fvmrc`. |
| `JAVA_HOME` | JDK used by Gradle (JDK 17 or newer). |
| `ANDROID_HOME`, `ANDROID_SDK_ROOT` | Android SDK, including the NDK version set in `ndkVersion`. |
| `CMAKE_ROOT_DIR` | Directory that contains `cmake`. |
| `NINJA_ROOT_DIR` | Directory that contains `ninja`. |
| `PATH` | Must include the Flutter, Dart, JDK, Android SDK, CMake, Ninja and Cargo binaries. |

Example:

```sh
# Local per-machine environment for building Azahar (not committed; see .gitignore).
# Usage: source .env.sh

export FLUTTER_ROOT=/opt/flutter-sdk/flutter
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export CMAKE_ROOT_DIR=/usr/bin
export NINJA_ROOT_DIR=/usr/bin
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT="$ANDROID_HOME"

export PATH="$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$HOME/.cargo/bin:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$CMAKE_ROOT_DIR:$NINJA_ROOT_DIR:$PATH"
export CMAKE_MAKE_PROGRAM="$NINJA_ROOT_DIR/ninja"
export CMAKE_GENERATOR=Ninja
```

## Environment setup

Set up the environment before you change any code. Run the real commands and fix the errors they report; do not guess what is broken by searching the source.

1. Install the Flutter SDK version from `.fvmrc`, then create `.env.sh` as shown above.
2. Fetch the submodules:

   ```sh
   git submodule update --init --recursive
   ```

   If GitHub returns HTTP 429, retry with `--jobs 1`.
3. Install the Rust toolchain (`cargo`). The Linux plugin builds `packages/azahar_rust` with it.
4. For the Linux desktop build, install the development packages:

   ```sh
   apt-get install -y libgtk-3-dev libevdev-dev libasound2-dev
   ```

5. Configure the C++ core in `build/` at the repository root. The Linux plugin runs `ninja` in that directory and links the libraries found there:

   ```sh
   source .env.sh
   mkdir -p build && cd build
   cmake ../packages/core -G Ninja -DCMAKE_BUILD_TYPE=Release -DENABLE_QT=OFF -DENABLE_TESTS=OFF -DENABLE_ROOM=OFF -DCITRA_USE_PRECOMPILED_HEADERS=OFF
   ```

6. For Android, install the SDK command-line tools in `$ANDROID_HOME/cmdline-tools/latest`, accept the licenses, and install the platform, build tools and NDK:

   ```sh
   source .env.sh
   yes | sdkmanager --licenses
   sdkmanager "platform-tools" "platforms;android-37.0" "build-tools;37.0.0" "ndk;28.2.13676358"
   ```

7. Resolve the Dart packages, generate code, and analyze:

   ```sh
   cd apps/flutter
   flutter pub get
   dart run build_runner build -d
   flutter analyze
   ```

8. Build:

   ```sh
   flutter build linux --debug
   flutter build apk --debug
   ```

   The Linux plugin collects the core libraries with `file(GLOB_RECURSE ...)` when CMake configures the Flutter build. On the very first build those libraries do not exist yet, so the link fails with undefined references to the core. Run `flutter build linux` again once the core has been built.

Add or remove Dart packages with `flutter pub add` and `flutter pub remove`; do not edit the dependency list in `pubspec.yaml` by hand.

## Saving command output

Write the output of every long-running or verbose command (builds, `flutter analyze`, `sdkmanager`, Gradle, CMake) to a log file in the session scratchpad, then read the whole file.

- Always overwrite the same log file. Do not create numbered copies such as `build2.log` or `build3.log`.
- Do not print the exit code with `echo`. The tool already reports whether the command failed.
- Do not filter the output while saving it. No `grep`, `tail`, `head` or `sed` in the pipeline.
- Read the log file in full and work from what it actually says.

Good:

```sh
flutter build linux --debug > "$SCRATCHPAD/build.log" 2>&1
```

Then read `$SCRATCHPAD/build.log` from start to end.

Bad:

```sh
# Filters the output, so the real error can be hidden.
flutter build linux --debug 2>&1 | grep -E "error|FAILED" | tail -25

# Prints the exit code.
flutter build linux --debug > "$SCRATCHPAD/build.log" 2>&1; echo "exit=$?"

# Creates a new numbered file for every run.
flutter build linux --debug > "$SCRATCHPAD/build2.log" 2>&1

# Writes the log outside the scratchpad.
flutter build linux --debug > /tmp/build.log 2>&1
```

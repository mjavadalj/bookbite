import com.android.build.api.dsl.LibraryExtension

allprojects {
      repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.myket.ir/")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Some Flutter plugins publish buildscript dependencies that target AGP
    // versions newer than the app toolchain. Keep every plugin on the same
    // tested Android/Kotlin plugin pair as the root project.
    buildscript.configurations.configureEach {
        resolutionStrategy.force(
            "com.android.tools.build:gradle:8.11.1",
            "org.jetbrains.kotlin:kotlin-gradle-plugin:2.2.20",
        )
    }
}

// Flutter's JNI support libraries currently request API 35, while this
// project intentionally installs and builds against API 36 only. Reapply the
// library compile SDK after each plugin's own build script has been evaluated,
// so a plugin-level compileSdk assignment cannot fall back to API 35.
subprojects {
    afterEvaluate {
        plugins.withId("com.android.library") {
            extensions.configure<LibraryExtension> {
                compileSdk = 36
                ndkVersion = "28.2.13676358"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
buildscript {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.myket.ir/")
        }
    }
}

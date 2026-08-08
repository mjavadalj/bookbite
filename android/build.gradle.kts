import com.android.build.api.dsl.LibraryExtension

allprojects {
      repositories {
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
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
buildscript {
    repositories {
        maven {
            url = uri("https://maven.myket.ir/")
        }
    }
}
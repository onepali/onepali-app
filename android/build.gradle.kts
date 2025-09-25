allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centralized Android SDK versions for all modules
ext {
    set("compileSdk", 36)
    set("minSdk", 24)
    set("targetSdk", 35)
    set("ndkVersion", "27.0.12077973")
    set("javaVersion", JavaVersion.VERSION_17)
    set("jvmTarget", "17")
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

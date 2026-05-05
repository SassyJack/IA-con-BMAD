allprojects {
    repositories {
        google()
        mavenCentral()
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

    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // Forzar versiones para todos los plugins
            android.compileSdkVersion(36)
            
            // Fix para error de "different roots" en Windows al trabajar entre discos D: y C:
            android.testOptions.unitTests.isIncludeAndroidResources = false
            
            if (android.namespace == null) {
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val manifest = groovy.xml.XmlParser().parse(manifestFile)
                    val pkg = manifest.attribute("package")
                    if (pkg != null) {
                        android.namespace = pkg.toString()
                    }
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

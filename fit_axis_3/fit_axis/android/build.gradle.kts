allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

subprojects {
    afterEvaluate {
        if (hasProperty("android")) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(34)
                // আপনার প্লাগইন যে NDK ভার্সনটি চাচ্ছে সেটি এখানে সব সাব-প্রজেক্টের জন্য ফিক্স করে দেওয়া হলো
                ndkVersion = "28.2.13676358"
                
                // এটি অনেক সময় APK না পাওয়ার সমস্যা সমাধান করে
                defaultConfig {
                    multiDexEnabled = true
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

import org.docbook.gradle.*

repositories {
  mavenLocal()
  mavenCentral()
  maven { url = uri("https://maven.saxonica.com/maven") }
}

val saxonVersion = project.properties["saxonVersion"].toString()
val xslTNGversion = project.properties["xslTNGversion"].toString()
val xmlCalabashVersion = project.properties["xmlCalabashVersion"].toString()
val docbookVersion = project.properties["docbookVersion"].toString()

plugins {
  id("org.docbook.xsltng-gradle") version "0.6.0"
}

val transformation by configurations.creating

dependencies {
  transformation("net.sf.saxon:Saxon-HE:${saxonVersion}")
  //transformation("com.saxonica:Saxon-EE:${saxonVersion}")
  transformation("org.docbook:schemas-docbook:${docbookVersion}")
  transformation("org.docbook:docbook-xslTNG:${xslTNGversion}")
  transformation("com.xmlcalabash:xmlcalabash:${xmlCalabashVersion}")
  transformation("com.xmlcalabash:app:${xmlCalabashVersion}")
}

configure<DocBookExtension> {
  classpath = configurations["transformation"]
  pipelineConfiguration = layout.projectDirectory.file("src/main/config.xml")
  debug = false
}

tasks.register<DocBookResources>("websiteResources") {
  output = layout.buildDirectory.dir("website")
}

val resources = tasks.register<Copy>("resources") {
  dependsOn("websiteResources")
  into(layout.buildDirectory.dir("website"))
  from(layout.projectDirectory.dir("src/main/resources"))
}

tasks.register<DocBookPipeline>("website") {
  dependsOn(resources)
  inputs.dir(layout.projectDirectory.dir("tools"))
  inputs.dir(layout.projectDirectory.dir("src/main/xml"))
  outputs.file(layout.buildDirectory.file("website/index.html"))

  pipeline = layout.projectDirectory.file("tools/pipeline.xpl")
  source = layout.projectDirectory.file("src/main/xml/index.xml")
  //result = layout.buildDirectory.file("website/index.html")
  //options = listOf("--debug", "--visualizer:detail")
  params = mapOf(
      "parameters" to mapOf(
          "local-conventions" to "file:${layout.projectDirectory.file("tools/local-conventions.xsl")}",
          "mediaobject-input-base-uri" to "file:${layout.buildDirectory.file("website").get().asFile}/",
          "mediaobject-output-base-uri" to "",
          "mediaobject-output-paths" to "true",
          "chunk" to "index.html",
          "chunk-output-base-uri" to "${layout.buildDirectory.file("website").get().asFile}/"
      )
  )
}

tasks.register("clean") {
  delete(layout.buildDirectory)
}

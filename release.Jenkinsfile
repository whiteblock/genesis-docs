@Library('whiteblock-dev')
import github.Release
import helm.Chart

def repo = 'genesis-docs'
String gitPullCredentialsId = 'github-repo-pac'
String imageName = 'docs'
String chartDir = './chart/genesis-docs'

def registry = 'gcr.io/infra-dev-249211'
// see: https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
def semverRegex = ~/^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/



pipeline {
  agent any
  environment {
    IMAGE_TAG = "${env.GIT_COMMIT}"
  }
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }
  parameters {
    string(name: "tag_name", description: "(REQUIRED) The name of the tag.")
    string(
      name: "target_commitish",
      defaultValue: "master",
      description: "Specifies the commitish value that determines where the Git tag is created from."
    )
    text(name: "body", defaultValue: '', description: "Description of the release")
  }
  stages {
    stage('validate tag') {
      steps {
        script {
          if (!(params.tag_name ==~ semverRegex)) {
            error("tag_name ${params.tag_name} must be a valid semantic version (http://semver.org)")
          }
        }
      }
    }
    stage('publish artifacts') {
      steps {
        script {
          source = new container.Image(
            registry: registry,
            name: imageName,
            tag: "${env.IMAGE_TAG}"
          )
          target = new container.Image(
            registry: registry,
            name: imageName,
            tag: "${params.tag_name}"
          )
          tagContainerImage(source, target)

          target = new container.Image(
            registry: registry,
            name: imageName,
            tag: "latest"
          )
          tagContainerImage(source, target)


          chart = new helm.Chart(
            directory: chartDir,
            version: params.tag_name
          )
          publishHelmChart(chart)
        }
      }
    }
    stage('github release') {
      steps {
        script {
          def release = new github.Release(
              tag_name: params.tag_name,
              body: params.body,
              target_commitish: params.target_commitish,
              repo: repo
          )
          withCredentials([
            usernameColonPassword(credentialsId: gitPullCredentialsId, variable: 'USERPASS')
          ]) {
            String text = createRelease(release, env.USERPASS)
            println text
          }
        }
      }
    }
  }
}

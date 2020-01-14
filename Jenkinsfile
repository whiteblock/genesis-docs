@Library('whiteblock-dev')_
import container.Image

String namespace = 'genesis-dev'
String releaseName = 'genesis-docs'
String defaultBranch = 'master'


pipeline {
  agent any
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }
  environment {
    IMAGE_TAG = "${env.GIT_COMMIT}"
  }
  stages {
    stage('build') {
      when { branch defaultBranch }
      steps {
        script {
          image = new container.Image(
            registry: 'gcr.io/infra-dev-249211',
            name: 'docs',
            tag: "${env.IMAGE_TAG}"
          )
          buildContainerImage(image)
        }
      }
    }
    stage('deploy') {
      when { branch defaultBranch }
      steps {
        helm("""--tiller-namespace helm upgrade ${releaseName} chart/genesis-docs \
            --install \
            --namespace ${namespace} \
            --set 'image.repository=${image.registry}/${image.name}' \
            --set 'image.tag=${image.tag}' \
            --wait"""
        )
      }
    }
  }
  post {
    always {
      slackNotify(env.BRANCH_NAME == defaultBranch)
    }
  }
}

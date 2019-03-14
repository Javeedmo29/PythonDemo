pipeline {
   environment {
    registry = "javeedmo29/dockerproject"
    registryCredential = 'dockerhub'
    dockerImage = ''
    containerId = sh(script: 'docker ps -aqf "name=java-app"', returnStdout: true) //to store your container id , so that it can be deleted
  }
  agent any
    stages 
    {
        stage('Building image') {
      steps{
        script {
          //will pisck registry from variable defined
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
     
       stage('Push Image') {
      steps{
        script {
                   
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
       }
       }
      }
    }
/*
       stage('Aqua MicroScanner') {
        steps{
       aquaMicroscanner imageName:'7459f109dc97', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
       
        }
    }
       
   /*   stage("Sonar scanner"){
       steps{
            sh"/opt/sonar/bin/sonar-scanner \
  -Dsonar.projectKey=aaa \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://52.172.54.204:9000 \
  -Dsonar.login=221209a103baa6816ed58bc2f92889f488342f70"
         
          }
       }*/
      stage('Cleanup') {
      when {
                not { environment ignoreCase: true, name: 'containerId', value: '' }
        }
      steps {
        sh 'docker stop ${containerId}'
        sh 'docker rm ${containerId}'
      }
    }
       
       
             
    stage('Run Container') {
      steps {
        sh 'docker run --name=java-app --privileged -d -p 8000:8000 -v /var/run/docker.sock:/var/run/docker.sock $registry:$BUILD_NUMBER &'
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi -f $registry:$BUILD_NUMBER"
      }
    }

       stage('ARACHNI Scanning') {
         steps {
            arachniScanner checks: '*', scope: [pageLimit: 3], url: 'http://52.172.25.128:8000/posts/', userConfig: [filename: 'myConfiguration.json'], format: 'json'
            step([$class: 'ArtifactArchiver', artifacts: 'alpha/arachni-report.json'])

            
            /*    post {
        success {
         publishHTML target: [
            allowMissing: false,
            alwaysLinkToLastBuild: false,
            keepAll: true,
            portDir: 'coverage',
            reportFiles: 'index.html',
            reportName: 'RCov Report'
          ]
        }
        
        }
*/ 
         }
      }

 }
}

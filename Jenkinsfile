pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('jenkins-gcp')
    PROJECT_ID = "instructor-20201020-student1xi-tfstate"
    DEFAULT_LOCAL_TMP = 'tmp/' 
//    ANSIBLE_USER = 'ubuntu'
    HOME='/tmp'
    
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p creds' 
        sh 'echo $SVC_ACCOUNT_KEY | base64 -di > ./creds/serviceaccount.json'
      }
    }

    stage('TF Plan') {
      steps {
          sh 'terraform init -reconfigure'
          sh 'terraform plan -var project_id=$PROJECT_ID -var jenkins_workers_project_id=$PROJECT_ID -out myplan'
        }
    }

    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        }
      }
    }

    stage('TF Apply') {
      steps {
          sh 'terraform apply -input=false myplan'
      }
    }
    
    stage('Debug') {
      steps {
          sh 'echo $DEFAULT_LOCAL_TMP'
          sh 'whoami'
          sh 'echo $USER'
      }
    }

    stage('Run Ansible playbook') {
       steps {
         withCredentials([sshUserPrivateKey(credentialsId: 'cicd-ssh-key', keyFileVariable: 'KEY')]) {
          sh 'echo $DEFAULT_LOCAL_TMP'
          sh 'echo $HOME'
          sh 'whoami'
          sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml -i tf.gcp.yml --private-key ${KEY} -b -u $ANSIBLE_USER'
      }
    }
   }
  }
 }

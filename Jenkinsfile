pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('tf-auth')
    DEFAULT_LOCAL_TMP = 'tmp/' 
    ANSIBLE_USER = 'jason'
    
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p creds' 
        sh 'echo $SVC_ACCOUNT_KEY | base64 -d > ./creds/serviceaccount.json'
      }
    }

    stage('TF Plan') {
      steps {
          sh 'terraform init'
          sh 'terraform plan -out myplan'
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
         withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'KEY')]) {
          sh 'echo $DEFAULT_LOCAL_TMP'
          sh 'whoami'
          sh 'ANSIBLE_LOCAL_TEMP=/tmp ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -vvvv playbook.yml -i tf.gcp.yml --private-key ${KEY} -b -u $ANSIBLE_USER'
    }
}
       /*  ansiblePlaybook(
          playbook: 'playbook.yml',
          inventory: 'tf.gcp.yml',
          credentialsId: 'ssh-key',
          installation: 'ansible',
          becomeUser: 'root'
          ) */
      }
    }
  }
//}

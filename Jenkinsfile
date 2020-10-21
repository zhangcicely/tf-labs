pipeline {
  agent any
  environment {
    SVC_ACCOUNT_KEY = credentials('jenkins-gcp')
      PROJECT_ID = 'student1gcp-istio'
      DEFAULT_LOCAL_TMP = 'tmp/'
      ANSIBLE_USER = 'ubuntu'
      HOME = '/tmp'
  }

  stages {
    stage('Cleanup') {
      steps {
        cleanWs(deleteDirs: true)
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p creds'
        sh 'echo $SVC_ACCOUNT_KEY | base64 -di > ./creds/jenkins-sa.json'
      }
    }

    stage('Install Terraform') {
      steps {
        sh 'curl -o terraform.zip https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip'
        sh 'unzip terraform.zip'
      }
    }

    stage('TF Plan') {
      steps {
        sh './terraform init -reconfigure'
        sh './terraform plan -var project_id=$PROJECT_ID -var jenkins_workers_project_id=$PROJECT_ID -out myplan'
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
        sh './terraform apply -input=false myplan'
      }
    }

/*    stage('Install Pip modules') {
      steps {
          sh 'pip3 install google-auth'
            sh 'pip3 install ansible'
      }
    } */

    stage('Run Ansible playbook') {
      steps {
        sh 'pip3 install ansible google-auth'
        withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'cicd-ssh-key', keyFileVariable: 'KEY')]) {
          sh 'ANSIBLE_HOST_KEY_CHECKING=False /tmp/.local/bin/ansible-playbook playbook.yml -i tf.gcp.yml --private-key ${KEY} -b -u $ANSIBLE_USER'
        }

      }
    }

  }
}

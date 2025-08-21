pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'DESTROY_BUDGET_ALERT',
            defaultValue: false,
            description: 'Set to true to destroy the budget alert after deployment'
        )
    }

    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Arshad2502/vmss_budgetalert_terraform.git'
            }
        }

        stage('VMSS Creation') {
            steps {
                dir('vmsscreate') {
                    sh 'terraform init'
                    sh 'terraform workspace new vmss || terraform workspace select vmss'
                    withCredentials([usernamePassword(
                        credentialsId: 'vmss-creds',
                        usernameVariable: 'TF_VAR_admin_username',
                        passwordVariable: 'TF_VAR_admin_password'
                    )]) {
                        sh 'terraform plan -out=tfplan'
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        stage('Budget Alert Creation') {
            steps {
                dir('budgetalertvmss') {
                    sh 'terraform init'
                    sh 'terraform workspace new budget || terraform workspace select budget'
                    sh 'terraform plan -out=budgetplan'
                    sh 'terraform apply -auto-approve budgetplan'
                }
            }
        }

        stage('Destroy Budget Alert') {
            when {
                expression { return params.DESTROY_BUDGET_ALERT }
            }
            steps {
                dir('budgetalertvmss') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success { echo "Pipeline completed successfully!" }
        failure { echo "Pipeline failed. Check the logs." }
    }
}

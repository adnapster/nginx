import groovy.json.JsonSlurper    

def response

int latestTag

pipeline {
    agent {
       label "build_1"
    }
     
    stages {
        stage('Build') {
            steps {
                checkout scm
                echo '..........................Building Jar..........................'
                echo 'Pulling................................................' + env.JOB_NAME
                
            }
        }
        stage('Build-Image') {
            steps {
                echo '..........................Building Image..........................'
                script {
                    if(env.JOB_NAME=="jcibts-clustered-swm-develop-nginx-bd"){
                        echo '.....................................Devlopment Image is Building.....................................'
                        sh 'sudo curl -k https://jcibts-swmdtr-dev.jci.com/ca -o /usr/local/share/ca-certificates/dockerdev.crt'
                        sh 'sudo update-ca-certificates'
                        sh 'sudo service docker restart'
                        sh 'sudo docker login https://jcibts-swmdtr-dev.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'
                        
                        response = sh(script: 'curl -X GET -u jcibtsucpadmin:x-eGHmXc[-5R@3W=, "https://jcibts-swmdtr-dev.jci.com/api/v0/repositories/jcibts_swm_dev/nginx/tags?pageSize=10&count=false&includeManifests=false" -H "accept: application/json"', returnStdout: true)
                        
                        
                        sh 'cd conf/clustered-develop/;sudo docker build -t jcibts-swmdtr-dev.jci.com/nginx:1 --build-arg PORT=8765 --build-arg ENVIRONMENT=clustered_develop .'
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-qa-nginx-bd"){
                        echo '.....................................QA Image is Building.....................................'
                        sh 'sudo curl -k https://jcibts-swmdtr-prod.jci.com/ca -o /usr/local/share/ca-certificates/dockerdev.crt'
                        sh 'sudo update-ca-certificates'
                        sh 'sudo service docker restart'
                        sh 'sudo docker login https://jcibts-swmdtr-prod.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'

                        response = sh(script: 'curl -X GET -u jcibtsucpadmin:x-eGHmXc[-5R@3W=, "https://jcibts-swmdtr-prod.jci.com/api/v0/repositories/jcibts_swm_qa/nginx/tags?pageSize=10&count=false&includeManifests=false" -H "accept: application/json"', returnStdout: true)
                        
                        
                        sh 'cd conf/clustered-qa/;sudo docker build -t jcibts-swmdtr-qa.jci.com/nginx:1 --build-arg PORT=8765 --build-arg ENVIRONMENT=clustered_qa .'
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-prod-nginx-bd"){
                        echo '.....................................Production Image is Building.....................................'
                        sh 'sudo curl -k https://jcibts-swmdtr-prod.jci.com/ca -o /usr/local/share/ca-certificates/dockerdev.crt'
                        sh 'sudo update-ca-certificates'
                        sh 'sudo service docker restart'
                        sh 'sudo docker login https://jcibts-swmdtr-prod.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'
                        
                        response = sh(script: 'curl -X GET -u jcibtsucpadmin:x-eGHmXc[-5R@3W=, "https://jcibts-swmdtr-prod.jci.com/api/v0/repositories/jcibts_swm_prod/nginx/tags?pageSize=10&count=false&includeManifests=false" -H "accept: application/json"', returnStdout: true)
                        
                        sh 'cd conf/clustered-production/;sudo docker build -t jcibts-swmdtr-prod.jci.com/nginx:1 --build-arg PORT=8765 --build-arg ENVIRONMENT=prod .'
                    }else{
                        echo '.....................................Specified Environment not found.....................................'
                    }
                     echo '=========================Response===================' + response
                        //echo '==============isEmpty===============' + response.isEmpty()

                    if(response!="[]"){    
                        echo '=========================Non Empty ==================='   
                        def parseResponse = new JsonSlurper().parseText(response)
                        echo '==========Original Tag===============' + parseResponse[0].name
                        
                        latestTag = parseResponse[0].name.toInteger()
                        latestTag = latestTag + 1
                        echo '==========Incremented Tag===============' + latestTag

                    }else{
                        echo '=========================Empty Case==================='
                        latestTag = 1 
                    }
                }
                
            }
        }
        stage('Tag-Image') {
            steps {
                echo '..........................Taging Image..........................'
                echo '..........latestTag.................' + latestTag
                script {
                    if(env.JOB_NAME=="jcibts-clustered-swm-develop-nginx-bd"){
                        echo '.....................................Develop Image is tagging.....................................'
                        //sh 'sudo docker login https://jcibts-swmdtr-dev.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'
                        sh 'sudo docker tag jcibts-swmdtr-dev.jci.com/nginx:1 jcibts-swmdtr-dev.jci.com/jcibts_swm_dev/nginx:'+latestTag
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-qa-nginx-bd"){
                        echo '.....................................QA Image is tagging.....................................'
                        //sh 'sudo docker login https://jcibts-swmdtr-prod.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'
                        sh 'sudo docker tag jcibts-swmdtr-qa.jci.com/nginx:1 jcibts-swmdtr-prod.jci.com/jcibts_swm_qa/nginx:'+latestTag
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-prod-nginx-bd"){
                        echo '.....................................Production Image is tagging.....................................'
                        //sh 'sudo docker login https://jcibts-swmdtr-prod.jci.com -u="jcibtsucpadmin" -p="x-eGHmXc[-5R@3W=,"'
                        sh 'sudo docker tag jcibts-swmdtr-prod.jci.com/nginx:1 jcibts-swmdtr-prod.jci.com/jcibts_swm_prod/nginx:'+latestTag
                    }else{
                        echo '.....................................Specified Environment not found.....................................'
                    }
                }
            }
        }
        stage('Push-Image') {
            steps {
                echo '..........................Pushing Image..........................'
                script {
                    if(env.JOB_NAME=="jcibts-clustered-swm-develop-nginx-bd"){
                        echo '.....................................Devlopment Image is pushing.....................................'
                        sh 'sudo docker push jcibts-swmdtr-dev.jci.com/jcibts_swm_dev/nginx:'+latestTag
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-qa-nginx-bd"){
                        echo '.....................................QA Image is Pushing.....................................'
                        sh 'sudo docker push jcibts-swmdtr-prod.jci.com/jcibts_swm_qa/nginx:'+latestTag
                    }else if(env.JOB_NAME=="jcibts-clustered-swm-prod-nginx-bd"){
                        echo '.....................................Production Image is pushing.....................................'
                        sh 'sudo docker push jcibts-swmdtr-prod.jci.com/jcibts_swm_prod/nginx:'+latestTag
                    }else{
                        echo '.....................................Specified Environment not found.....................................'
                    }
                }
            }
        }
              
    }
}
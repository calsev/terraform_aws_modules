# Changelog

## 0.33.0

### General

* Make DNS optional for CDN

## 0.32.0

### General

* Streamline API for ECS app

## 0.31.1

### General

* Add data key and format to pipe stack

## 0.31.0

### General

* Regularize CI/CD pipe stack

## 0.30.1

### Bugfix

* Fix condition for context in CI/CD name

## 0.30.0

* ECS application
* CI/CD deployment group

### General

* Regularize CI/CD build names
* Add deploy roles to CI/CD IAM app
* Support build and deploy for embedded pipe

## 0.29.0

### New modules

* CI/CD deployment app
* CI/CD deployment config
* CI/CD embedded pipe

### General

* Add alarm config for ECS service
* ELB default listeners now mapped by protocol and port
* Enforce lowercase names
* Add HTTP alt to default security group map

## 0.28.0

### New modules

* ELB listener
* ELB Listener certificate
* ELB load balancer
* ELB target group

### General

* Retool role policy parameters
* Add support for ELB to ASG and ECS cluster
* Expand parameterization of ECS service
* Embed role and log group in ECS task
* Tighten default host memory for ECS task
* Conform Python scripts to strict type checking

## 0.27.0

### New modules

* Config AWS account
* Password policy

### General

* Add entry point for Batch job
* Add environment variables for CI/Cd build
* Add email and MFA config for COgnito user pool
* Expand parameterization for log group
* Add script for generating variables and locals for new module
* Tighten host memory default for ECS tasks
* Support ELB logging in S3 policy
* Add DMARC for SES identity
* Add internal HTTP to default security groups

## 0.26.0

### New modules

* RDS proxy

## 0.25.0

### General

* Support parallel stages for web app

## 0.24.0

### General

* Update Batch compute for obsolete attribute
* Add schema for Cognito

## 0.23.0

### New modules

* Lambda permission

### General

* Add lambda triggers for Cognito user pool

## 0.22.1

### Bugfix

* Workaround for validations for certs with SANs

## 0.22.0

### General

* Support subject alternate names for certs
* Include AP policy for buckets by default

### Bugfix

* CDN FQDN now supports dashes
* Re-create Codepipeline webhook on connection change

## 0.21.0

### General

* Flatten secret data

## 0.20.0

### New modules

* EC2 key pair

## 0.19.0

### New modules

* Application for OpenVPN instance
* IAM role for EC2 instance

### General

* Uplift stage logs into API Gateway Stage module
* Update EC2 user data to AL2023
* Remove unnecessary log policy from API Gateway role

## 0.18.1

### New modules

* IAM app for EC2

### General

* Support suppressing sensitive user data in outputs
* Regularize name handling for roles

### Bugfix

* Fixed some kebob-case keys
* Fixed cert challenge keys depending on post-apply values

## 0.18.0

### General

* Add policy mapping to base role

## 0.17.0

### New modules

* DNS record
* EC2 auto scaling group
* EC2 elastic IP
* EC2 network interface

### General

* Enforce resource key case convention
* Standardized DNS usage

## 0.16.0

### General

* Enforce snake case for resource keys
* Add default lambda policy for ECR repos

### Bugfix

* Move script now supports spaces in resource names

## 0.15.0

### New modules

* CDN public key
* CDN public key group
* Random TLS key

### General

* Added trusted keys to CDN
* Added support for JSON params in SSM
* Fix Cognito pool without custom domain
* Add support for initial value in secret

## 0.14.0

### New modules

* Cache policy for CDN
* Origin request policy for CDN
* CI/CD remote host
* CI/CD remote connection

### General

* Added support for removing app context from names
* Moved cdn/distribution from cdn
* Moved iam/policy/managed from iam/policy_managed
* Moved iam/policy/map from iam/policy_map
* Moved iam/policy/name_map from iam/policy_name_map
* Removed obsolete iam/assume_role_map
* RDS instance now embeds a random password secret

## 0.13.0

### New modules

* Role for CodePipeline
* Random password
* Secret initialization map
* Secret with random initialization

### General

* Update default CodePipeline to V2
* Added secret for CodePipe webhook
* Collated CDN output by key
* Moved secret/data from secret

### Bugfix

* Fixed dirty plan for empty CDN CORS header lists

## 0.12.1

### Bugfix

* Fix conflict between S3 object ownership and ACL

## 0.12.0

### General

* Fully namespace modules by service

## 0.11.1

### General

* Fix API auth for preflight requests

## 0.11.0

### New modules

* API Gateway API
* API Gateway domain

### General

* Add example for API auth

## 0.10.0

### New modules

* Cognito client app

### Feature

* Add Cognito auth to API stack

### General

* Reorganized Cognito modules into subdirectories to reduce vertical size
* Reorganized event modules into subdirectories to reduce vertical size
* Reorganized pinpoint modules into subdirectories to reduce vertical size
* Reorganized SQS modules into subdirectories to reduce vertical size
* Reorganized SSM modules into subdirectories to reduce vertical size

## 0.9.0

### Feature

* Add response header policy for CDN

### General

* Add example for API Gateway
* Add example for DNS
* Add example for CDN global resources

## 0.8.0

### Feature

* Add embedded policy to Step Function
* Add embedded policy to Lambda

### General

* Reorganized CI/CD modules into subdirectories to reduce vertical size
* Reorganized ECS modules into subdirectories to reduce vertical size

## 0.7.0

### Feature

* Added service designation for API Gateway integration
* Removed certificate from API Gateway. Cert is now passed in DNS data.

### Bugfix

* Name map no longer replaces punctuation in suffixes. This fixes ".fifo" -> "-fifo" conversion for SQS

### General

* Reorganized API Gateway modules into subdirectories to reduce vertical size
* Local config now uses sensitive file to avoid large diffs

## 0.6.0

### General

* Moved IAM modules into subdirectories to reduce vertical size

## 0.5.0

### New modules

* API Gateway authorizer
* Cognito user pool
* Mobile Analytics IAM app
* Mobile Analytics IAM policy
* Pinpoint app
* Pinpoint email channel
* Pinpoint SMS channel
* SES configuration set
* SES domain identity
* SES email identity
* SMS account

### General

* Module template
* More attributes for DynamoDB table
* More examples
* Update compute defaults to AL 2023
* Uplift archive handling into Lambda function

## 0.4.0

### New modules

* Lambda function
* Dead letter queue
* Event alert

### General

* Improved handling of custom policies for embedded roles

## 0.3.0

### New modules

* RDS policy
* S3 access point
* S3 event rules and targets
* Systems Manager secret
* Systems Manager secret policy

### General

* AWS provider version 5 support
* ECS env file support
* Scaling tightened for Batch/ECS host memory

## 0.2.0

### General

* Level-sets implementation paradigm

## 0.1.0

### General

* Initial public release

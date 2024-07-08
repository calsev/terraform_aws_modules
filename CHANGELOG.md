# Changelog

## 0.67.0

### New modules

* Backup plan
* Backup selection

## 0.66.0

### New modules

* Backup vault
* IAM app for Backup

## 0.65.0

### New modules

* GuardDuty detector
* Inspector enabler

## 0.64.0

### General

* Separate security groups for ECS app service and instance

## 0.63.0

### New modules

* App alert AWS account (was SNS alert AWS account)
* Cloudwatch log metric filter
* Cloudwatch metric alarm

### General

* Policy map parameterize default policies
* S3 support for WAF logging
* Subnets do not map public IPs by default

## 0.62.0

### New modules

* Config recorder
* S3 public access block

### General

* Config AWS account creates recorder
* Combine policies for assume role

## 0.61.0

### New modules

* KMS key identity policy
* KMS key resource policy
* KMS Key

### General

* Support KMS encryption for Cloudtrail trail

## 0.60.1

### General

* Add several examples

## 0.60.0

### New modules

* Account alternate contact
* Budgets budget
* Cloudtrail trail
* EC2 flow log
* IAM app for AWS support
* IAM service-linked role

### General

* Config service-linked role created by default
* S3 resource policy for Config recording
* Default requirements for passwords hardened
* Update S3 access point
* VPC NACL deny external SSH and RDP by default
* VPC flow log by default

## 0.59.0

### General

* WAF for ELB
* S3 buckets versioned by default
* Update WAF

## 0.58.0

### New modules

* ECS task execution role

### General

* ECR mirror pushes all architectures
* Default name append for RDS password secret
* Security group app is now a drop-in replacement for vpc_data_map

## 0.57.0

### General

* EC2 volumes encrypted by default
* EBS default encryption added to ECS account
* ELB deletion protection and drop invalid headers by default
* Secure transport policy for S3 buckets
* Log export for RDS by default

## 0.56.0

### New modules

* Access Analyzer analyzer

### General

* Directory internal by default
* Add default security group for Active Directory

### Bugfix

* Fix target protocol for OpenVPN TCP listener

## 0.55.0

### New modules

* Instance connect endpoint

### General

* Add ELB support to OpenVPN
* Add EC2 connect to VPC networking
* Add suspended processes to ALB
* Add SSM Managed instance permissions to base instance profile

## 0.54.0

### General

* Support NLB target and listener

## 0.53.0

### New modules

* Workspaces workspace

### General

* Add default rules for RDP

## 0.52.0

### New modules

* Workspaces default role
* Workspaces directory

### General

* Support all networking modes for ELB

## 0.51.0

### New modules

* Directory Service Directory

### General

* Creation flags for costly resources
* Default lifecycle rule for intelligent tiering
* Standardize keys for VPC resources

## 0.50.0

### New modules

* IAM policy for ECS service

### General

* Support multi-port ECS apps

## 0.49.0

### General

* Refactor certificate and rules for ECS app into ELB target map

### Bugfix

* Fix target key for ECS app with custom ELB target and blue-green deployment

## 0.48.0

### New modules

* Access resource policy for S3 bucket

### General

* Refactor ELB target map for ECS service
* ELB listener forward rule default to weight of 1
* Remove conditions for log resource policies for event account
* Improve name handling for base identity policy
* Add embedded policy for S3 bucket

## 0.47.1

### General

* Namespace ELB log databases

## 0.47.0

### New modules

* Athena database
* Athena named query

### General

* Add Athena database for ELB

## 0.46.0

### General

* Add image arch list to ECS app

## 0.45.0

### General

* Add Docker volume map to ECS app

## 0.44.1

### General

* Parameterize CodeBuild data key for ECS app

## 0.44.0

### General

* Embed image build in ECS app

## 0.43.0

### New modules

* CI/CD build for multi-arch image

### General

* Support Fargate for ECS app
* Embedded policy for image permission for CodeBuild role
* Append name for pipe webhook secret
* Hard code no name app fields for ELB target
* Lifecycle create before destroy for roles and policies
* Name map support for append and prepend

## 0.42.0

### General

* Consolidate `app/ecr_repo_mirror` from `ecr/repo_mirror` and `app/ecr_mirror` 
* Improve parameterization of Fargate cluster

## 0.41.0

### General

* Add support for NLB
* Add default SG rule for internal OpenVPN

## 0.40.0

### General

* Per-stage domain mapping for API Gateway
* Embed log group and policy in Step Function

## 0.39.1

### General

* Clarify names for builds

## 0.39.0

### General

* Improve parameterization and name handling for CDN modules

## 0.38.0

### New modules

* Default VPC

### General

* OpenVPN instance allows only internal SSH by default
* Params for reduced privilege for Batch job
* Remove standard ACL permissions for S3 policies
* Require metadata V2 for launch template by default
* Params for reduced privilege for ECS task
* Elasticache backup enabled by default
* ELB security groups limited to internal testing access
* S3 CloudTrail logging
* S3 server access logging
* Remove default world-accessible HTTP-alt, SSH security groups

## 0.37.0

### New modules

* Elasticache cluster
* Elasticache parameter group
* Elasticache subnet group

### General

* Default security groups for Redis and Memcached
* Example for ECS configuration

## 0.36.0

### New modules

* IAM policy for Bedrock models and jobs

### General

* Add key pair for ECS app

## 0.35.1

### General

* Add client timeouts to Cognito pool

## 0.35.0

### General

* Improve all default templates for Cognito

## 0.34.0

### General

* Create full revision spec for ECS app
* Improve default subject for Cognito user pool validation email
* Improve handling of Cognito data for ELB
* Standardize name usage for RDS
* Add special character list for random password
* Example for ECS app
* Example for RDS and Cognito pool
* Example for SES email

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

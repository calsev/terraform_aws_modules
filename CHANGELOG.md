# Changelog

## 0.12.0

General

* Fully namespace modules by service

## 0.11.1

General

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

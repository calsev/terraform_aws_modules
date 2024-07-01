# Terraform AWS Modules

[![License](https://img.shields.io/github/license/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Tag](https://img.shields.io/github/tag/calsev/terraform_aws_modules?sort=semver)](https://github.com/calsev/terraform_aws_modules)

[![Issues](https://img.shields.io/github/issues/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Last Commit](https://img.shields.io/github/last-commit/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Build](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiVU9EbWdMTTZkTFM2QWhiWlVyd2wzNnlZa1pkNVorQUxpc1lTMUVZY1g4bDJRRkphRG5KTXYwa29CRCs4a2NsY0dvQ0prZHpqd093bHVQZDlMWHNHbGY4PSIsIml2UGFyYW1ldGVyU3BlYyI6IjVmY0tmLzFZdnNKZGlpYmsiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)](https://github.com/calsev/terraform_aws_modules)

## Purpose

This library provides modules to configure many common AWS resources.
The modules follow a consistent, opinionated programming and data flow paradigm,
but are highly parameterized and un-opinionated in how they configure resources.

## Installation

Because this library is heavily refactored into utility modules,
the entire library is typically embedded as a git submodule and modules used from local paths,
rather than as Terraform source modules.

```shell
git submodule add path/to/terraform/modules/this-library
```

## Requirements

### Terraform

Modules make extensive use of optional parameters as introduced in [Terraform 1.3](https://www.hashicorp.com/blog/terraform-1-3-improves-extensibility-and-maintainability-of-terraform-modules).

### Dependencies

This module set has no external dependencies or submodules.

## Usage paradigms

Some common paradigms used by this library are enumerated below.

### Item map

Most modules in this library support creating multiple items.
The basic paradigm is outlined below.

```terraform
variable "global_attribute" {
  type =        string
  description = "I am used by all items in this module"
}

variable "item_map" {
  type = map(object({
    some_attribute = optional(string) # Most attributes will be optional
  }))
}

variable "item_some_attribute_default" {
  type =        string
  description = "I am injected into items for which a corresponding attribute is not set. Generally I default to the most conservative value."
}
```

The output from such modules will be a map containing:

* Effective values of possibly defaulted attributes
* Synthesized attributes
* Attributes of created resources
* Sub-objects for embedded modules

A Notable exception to this paradigm is IAM modules that always create a single IAM entity.

### Context from std_map

Modules universally take a context object called `std_map`.
This struct can be created using the [common module](common) and by passing typically 3 variables for `app`, `region_name` and `env`.
This context provides:

* Prefix and suffix for consistent resource naming
* AWS region name
* Default AWS account ID
* IAM actions per service
* Other common parameters...

One `std_map` context is used per region and environment, in a `for_each` loop.
Examples of multi-region, multi-environment usage are given below.

### Naming

Most modules support a standard naming convention that distinguishes:

* `name_simple` The key of the item, possibly with substitutions
* `name_context` The "full" name of the item, including context for app, env, region, and Terraform workspace.
  This name is always used in tags to fully identify the resource
* `name_effective` The actual name of the resource - either `name_simple` or `name_effective` depending on
* `name_infix` A flag to choose the effective name

Modules default to `name_infix = true`.
This is usually appropriate for internal and "glue" resources so they are easy to track down,
but is usually changed for external-facing resources or resources with lifetimes that transcend management in Terraform.

### Trivial, structured output

The vast majority of modules provide a single output object named `data`.
Thus outputs from modules are easy to aggregate.

This is done for two reasons. First, the internal structure of the modules is largely opaque to clients.
Many modules will consume output from other modules as a 'data map' and a key into that map.
The consuming module handles extraction of low-level strings, lists, etc. from the structured output of its dependencies.
As a result, upgrading typically requires only remapping inputs to root modules.

Second, a JSON record of all resources created by an app and their configurations can usually be generated with little difficulty.

```terraform
locals {
  output_data = {
    one   = module.one.data
    two   = module.two.data
    three = module.three.data
  }
}

module "local_config" {
  source  = "../../../modules/local_config"
  content = local.output_data # Aggregated output from all root modules
  std_map = module.com_lib.std_map
}
```

This output enables easy consumption of terraform configuration from other languages.
This paradigm is used extensively in the examples.

One notable exception is modules that create secrets. These provide separate outputs for secret content to avoid inadvertent aggregation of sensitive data.

### Networking from vpc_data_map

Rather than lists of CIDRs and subnet IDs and security group IDs,
modules that require networking take a `vpc_data_map` and each item in the list takes a

* `vpc_key` to identify which VPC
* `vpc_segment_key` to identify the network segment
* `vpc_az_key_list` to identify which AZs to deploy to, corresponding to the `a`, `b`, `c`, ... AZs for the AWS account

Low-level lists of IDs are synthesized.

### Permissions by access level

IAM policies can be created by hand,
but this library typically does not bother with individual actions.
Instead, policies are generated by resource type and access level, as below.

```terraform
module "image_policy" {
  source      = "../iam_policy_identity_ecr"
  access_list = ["read_write"]
  name        = "example-repo-policy"
  repo_name   = "example-repo"
  std_map     = var.std_map
}

module "bucket_policy" {
  source   = "../iam_policy_identity_s3"
  sid_map = {
    Artifact = {
      access           = "write"
      bucket_name_list = ["example-bucket"]
      object_key_list  = ["some-path/*"]
    }
  }
  name    = "write-bucket-policy"
  std_map = var.std_map
}
```

The above examples show two paradigms used by identity-based policies.
When permission is typically granted to an entire resource, as with an ECR repo,
the policy module will take just a list of access levels.
The output from the module will contain an `iam_policy_doc_map`,
and optionally a non-null `iam_policy_arn_map` if a policy name is provided.
Both of these maps are indexed by access level.

When permission is typically granted to a subdivision of a resource, as with specific S3 object keys,
the policy module will take a `sid_map`.
The output from the module will be a singular `iam_policy_doc`,
and optionally a non-null `iam_policy_arn` if a policy name is provided.

Read and write permissions granted in this way refer to only _using_ the resource. 
Permission for management actions such as attaching policies or adding configurations is never granted in this manner.

## Examples

### S3 buckets and Terraform locks

To get started with Terraform, typically an S3 bucket for the backend and a DynamoDB table for locks is required.
These can be created as in [this example](documentation/example/inf/s3).
Also demonstrated are:

* Multi-region usage
* S3 websites
* S3 access points

### VPC networking

For an example of creating VPC networking infrastructure the easy way, [see this example](documentation/example/inf/net).
This app uses the [vpc/stack module](vpc/stack) to create multiple peered VPCs in a few lines.
This example will work for most AWS accounts for startups by modifying only the CIDR of the VPC.
For finer-grained control and advanced usage, see the underlying [vpc/networking module](vpc/networking).

In this example an ELB is also instantiated with standard HTTP and HTTPS listeners.

Notably, this example app generates output that is suitable for usage as the `vpc_data_map` variable that is expected by many other modules.
Specifically, the output of this example can be imported and passed as `vpc_data_map = data.terraform_remote_state.net.outputs.data.vpc_map`.

### IAM and monitoring

IAM modules provide "apps" for several services. These create the resources that will be required in pretty much any AWS account where these services are utilized.
These applications are [instantiated here](documentation/example/inf/iam). Notably, output from this app is usable for any module that requires IAM data as `iam_data = data.terraform_remote_state.iam.outputs.data`.

[This example](documentation/example/inf/monitor) demonstrates creation of trails, dashboards, event bus logging, alerting. Notably, output from this app can be consumed by modules as `monitor_data = data.terraform_remote_state.monitor.outputs.data`.

### DNS

This [example](documentation/example/inf/dns) uses the [dns/zone module](dns/zone) to generate multiple hosted zones.
It also demonstrates using the [dns/sd_public module](dns/sd_public) to create a service discovery domain.
Finally, the [cert module](cert) is used to create multiple ACM certificates.

Notably, the output from this example app can be imported and passed to many modules as `dns_data = data.terraform_remote_state.dns.outputs.data`.

### CDN

[This example](documentation/example/inf/cdn_global) uses the [cert module](cert) and [waf module](waf) to generate multiple hosted zones.
It also shows some reusable request and caching policies for Cloudfront.

Notably, the output from this example app can be imported and passed to modules as `cdn_global_data = data.terraform_remote_state.cdn_global.outputs.data`.

A CDN and signing keys are [created here](documentation/example/inf/cdn). This example also demonstrates how to create a CDN for private content.

### Communications

[This example](documentation/example/inf/comms) uses the [Domain identity](ses/domain_identity) and [Email identity](ses/email_identity) modules to create SES email resources for use in alerting and user-facing emails.

Notably, the output from this example can be passed to modules as `comms_data = data.terraform_remote_state.comms.outputs.data`.

### Data persistence

[This example](documentation/example/data/core) uses the [RDS instance](rds/instance) and [Cognito user pool](cognito/user_pool) modules to create persistent data stores.

Notably, the output from this example app can be passed to modules as `cognito_data_map = data.terraform_remote_state.core.outputs.data.user_pool`.

### ECR, ECS, and Batch

This [small example](documentation/example/inf/ecr) uses the [ecr/repo module](ecr/repo) to generate `ecr_data` as expected by modules that use a container.

Notably, the output from this example app can be imported and passed as `ecr_data = data.terraform_remote_state.ecr.outputs.data`.

The [ECS example](documentation/example/inf/ecs) uses the [ecs/ami_map](ecs/ami_map) module to generate a record of the latest ECS AMIs, as well as the [ecs/aws_account](ecs/aws_account) module to set account options for ECS. The [batch/compute](batch/compute) module is used to create several Batch clusters.

### CI/CD

[This example](documentation/example/inf/ci_cd) demonstrates creation of the account-level resources that are needed for CI/CD. These resources include CodeStar connection, S3 bucket, log groups, and reusable roles. Notably, the output from this module is suitable for passing to CI/CD modules as `ci_cd_account_data = data.terraform_remote_state.ci_cd.outputs.data`.

Creation of CI/CD for a repository is [demonstrated here](documentation/example/code/tf). This includes a pipeline and public build log.

### S3 object ingestion

The example [app/s3_proc](documentation/example/app/s3_proc)
shows two common patterns in an AWS account

* Triggering a process based on an S3 upload
* Processing data using Batch

### Lambda functions

The example [app/lambda](documentation/example/app/lambda)
shows examples of lambda functions from several sources

* Create archive from local directory
* Create archive from local directory and create S3 archive
* Use existing local archive
* Use existing archive and create S3 archive
* Use existing S3 archive

### API Gateway Integrations

The example [app/api](documentation/example/app/api)
provides code to create several targets:

* Lambda function
* SQS queue
* State machine

Integrations for each of these with API Gateway are also shown.
Stage mapping by hostname is shown in this example.

### API Gateway Auth

The example [app/api_auth](documentation/example/app/api_auth)
provides an example of integrating authorization with API Gateway:

* Lambda authorizer
* Cognito user pool and JWT token

Stage mapping by path is shown in this example.

### ECS service

The example [app/web_backend](documentation/example/app/web_backend)
shows the creation of a web backend service including DNS, load balancing, auto scaling, monitoring, alerting, CI/CD in one module using the high-level [app/ecs_app module](app/ecs_app).

### Static web app

A frontend website is deployed in example [app/web_static](documentation/example/app/web_static). This makes use of the high-level [app/web_static module](app/web_static) to create the CDN and CI/CD in few lines of code.

## Development scripts

This library provides some scripts to improve quality of life for the Terraform developer.

### Auto move

Terraform provides a programmatic `move` resource, but these do not support `for_each`.
The [script/tf_move.py](script/tf_move.py) provides a CLI for interactive movement of all resources after a refactor or upgrading this library.

### Auto import of S3 buckets

An S3 bucket requires upwards of a dozen resources to manage in Terraform.
The [script/s3_import](script/s3_import.py) makes importing existing S3 buckets less tedious.
All resources supported by the [s3 module](s3) will be imported for each bucket that is being created by a plan, if they exist.
Remaining resources can be created without risk of overwriting existing configuration.
Note that the bucket itself should not be imported before running this script.

### App target generation

Products such as [Terragrunt](https://terragrunt.gruntwork.io/)
extend Terraform by providing `for_each` semantics for common Terraform commands.

This library also provides a Makefile generator that cen be used to generate make targets for each Terraform app.
TODO: Example

## Maintainers

* [Caleb Severn](https://github.com/calsev)

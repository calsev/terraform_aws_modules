# Terraform AWS Modules

[![License](https://img.shields.io/github/license/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Tag](https://img.shields.io/github/tag/calsev/terraform_aws_modules?sort=semver)](https://github.com/calsev/terraform_aws_modules)

[![Issues](https://img.shields.io/github/issues/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Last Commit](https://img.shields.io/github/last-commit/calsev/terraform_aws_modules)](https://github.com/calsev/terraform_aws_modules)

[![Build](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiVU9EbWdMTTZkTFM2QWhiWlVyd2wzNnlZa1pkNVorQUxpc1lTMUVZY1g4bDJRRkphRG5KTXYwa29CRCs4a2NsY0dvQ0prZHpqd093bHVQZDlMWHNHbGY4PSIsIml2UGFyYW1ldGVyU3BlYyI6IjVmY0tmLzFZdnNKZGlpYmsiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)](https://github.com/calsev/terraform_aws_modules)

## Purpose

This library provides modules to configure many common AWS resources.
The modules follow a consistent, opinionated programming and data flow paradigm,
but are configurable and un-opinionated in how they configure resources.

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

## Usage

### Common paradigms

#### Item map

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
  description = "I am injected into items for which a corresponding attribute is not set. Generally I am the most conservative value."
}
```

The output from such modules will be a map containing:

* Effective values of possibly defaulted attributes
* Synthesized attributes
* Attributes of created resources
* Sub-objects for embedded modules

A Notable exception to this paradigm is IAM modules that always create a single IAM entity.

#### Context from std_map

Modules universally take a context object called `std_map`.
This struct can be created using the [common module](common) and by passing typically 3 variables for `app`, `region_name` and `env`.
This context provides:

* prefix and suffix for consistent resource naming
* AWS region name
* Default AWS account ID
* IAM actions per service
* Other common parameters...

One `std_map` context is used per region and environment, in a `for_each` loop.
Examples of multi-region, multi-environment usage are given below.


#### Naming

Most modules support a standard naming convention that distinguishes:

* `name_simple` The key of the item, possibly with substitutions
* `name_context` The "full" name of the item, including context for app, env, region, and Terraform workspace.
  This name is always used in tags to fully identify the resource
* `name_effective` The actual name of the resource - either `name_simple` or `name_effective` depending on
* `name_infix` A flag to choose the effective name

Modules default to `name_infix = true`.
This is usually appropriate for internal and "glue" resources so they are easy to track down,
but is usually changed for external-facing resources or resources with lifetimes that transcend management in Terraform.

#### Networking from vpc_data_map

Rather than lists of CIDRs and subnet IDs and security group IDs,
modules that require networking take a `vpc_data_map` and each item in the list takes a

* `vpc_key` to identify which VPC
* `vpc_segment_key` to identify the network segment
* `vpc_az_key_list` to identify which AZs to deploy to

Low-level data like subnet IDs are synthesized.

### Examples

#### S3 buckets and Terraform locks

To get started with Terraform, typically an S3 bucket for the backend and a DynamoDB table for locks is required.
These can be created as in [this example]().
Also demonstrated are:

* Multi-region usage
* S3 websites
* S3 access points

#### VPC networking

For an example of creating VPC networking infrastructure the easy way, [see this example](documentation/example/inf/net).
This app uses the [vpc_stack module](vpc_stack) to create multiple peered VPCs in a few lines.
This will work for most AWS accounts for startups by modifying only the CIDR of the VPC.
For finer-grained control and advanced usage, see the [vpc_networking module](vpc_networking).

Notably, this example app generates output that is suitable for usage as the `vpc_data_map` variable that is expected by many other modules.
Specifically, the output of this example can be imported and passed as `data.terraform_remote_state.this-example-app.outputs.data.vpc_map`.

## Maintainers

* [Caleb Severn](https://github.com/calsev)

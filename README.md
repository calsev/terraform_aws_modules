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

## Usage

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

## Maintainers

* [Caleb Severn](https://github.com/calsev)

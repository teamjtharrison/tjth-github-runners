# tjth-github-runners

AWS (terraform) deployment for github runners

This solution runs end-to-end via Terraform / Github runners and will deploy a self-hosted runner to be used across an Org.

# Deployment 

Top level directories will be deployed in sequence to create appropriate resources for an AWS hosted Github runner.

## 0_runner_role

Should be run locally to bootstrap the pipeline (Creating a role that can be used by Github to deploy the runners. 

## 1_create_runner

Github actions will deploy Terraform resources required for a Github runner in AWS. NOTE: For obvious reasons this must run on Github hardware - Due to Security concerns the IAM role used by Github hosted runners is restricted to creating these resources.

## 2_demo_deploy_resources

Github actions will deploy resources into the AWS account using the newly deployed self-hosted Github runner.

# Modules

The modules in this repo are referenced via remote git addresses to allow module semver differences per deployed resource (For shared resources these should be hosted in an external modules repo). For example testing a new version of a module before production deployment.



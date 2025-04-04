# Simple Webpage

## TerraForm and Ansible

Keep your AWS credentials in a secret place.

[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

An AWS configuration file, typically located at:

`~/.aws/credentials`

The file should look like this:

```plaintext
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```

In your Terraform configuration, you can reference these credentials using the `profile` attribute:

```hcl
provider "aws" {
  profile = "default" # Use the profile name from your AWS CLI configuration
  region  = "us-east-1"
}
```

Get the Jenkins pipelines from the scripts folder.

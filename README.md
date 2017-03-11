Test policy required to upload files to an S3 bucket

Software dependencies::

* bash
* [jq](https://stedolan.github.io/jq/)
* [AWS CLI](https://aws.amazon.com/cli/)

AWS preparation:

* an admin user for the target AWS account
* an IAM user to test uploading
* an S3 bucket

Local preparation:

* Configure `~/.aws/config` and `~/.aws/credentials` with profiles for the admin user and for the upload user
* Copy `settings.conf.example` to `settings.conf` and set appropriate values

Test cycle:

1. Create the policy document with `./build_policy.bash`
2. Create the policy and attach it to the upload user with `./apply_policy.bash`
3. Test uploading with `./upload_to_s3.bash`
4. If there are errors, edit `build_policy.bash` to adjust policy and go back to step 1

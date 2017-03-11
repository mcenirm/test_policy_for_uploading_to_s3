#!/bin/bash

set -e
set -u

. settings.conf

export AWS_DEFAULT_PROFILE=${uploader}

set -x

aws s3 ls
aws s3 ls "s3://$bucket" --recursive
aws s3 cp test.txt "s3://${bucket}/test.txt"
aws s3 ls "s3://$bucket" --recursive

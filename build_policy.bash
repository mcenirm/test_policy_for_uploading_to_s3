#!/bin/bash

set -e
set -u

. settings.conf

time=$( date +%s )
previous_policy=$( basename "$( find . -name "${policy}-policy.*.json" -print | sort | tail -n 1 )" )
new_policy=${policy}-policy.${time}.json

jq -S . > "$new_policy" <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::*"
      ],
      "Sid": "Stmt${time}000"
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${bucket}"
      ],
      "Sid": "Stmt${time}001"
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${bucket}/*"
      ],
      "Sid": "Stmt${time}002"
    }
  ],
  "Version": "2012-10-17"
}
EOF

diff -u "$previous_policy" "$new_policy"

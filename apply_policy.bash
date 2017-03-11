#!/bin/bash

set -e
set -u

. settings.conf

export AWS_DEFAULT_PROFILE=${admin}

policy_document=$( basename "$( find . -name "${policy}-policy.*.json" -print | sort | tail -n 1 )" )
policy_name=${policy_document%.json}
policy_response=${policy_document/-policy./-response.}

echo == Detaching existing policies
for policy_arn in $( aws iam list-attached-user-policies --user-name "$uploader" | jq -r '.AttachedPolicies[].PolicyArn' ) ; do
  ( set -x ; aws iam detach-user-policy --user-name "$uploader" --policy-arn "$policy_arn" )
done

echo == Creating policy
(
  set -x
  aws iam create-policy \
      --policy-name "$policy_name" \
      --policy-document "file://$policy_document"
) | jq -S . | tee "$policy_response"

policy_arn=$( cat "$policy_response" | jq -r '.Policy.Arn' )

echo == Attaching new policy
(
  set -x
  aws iam attach-user-policy \
      --user-name "$uploader" \
      --policy-arn "$policy_arn"
)

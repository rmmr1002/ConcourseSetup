#!/bin/bash

set -eu

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export fly_target=${fly_target:-tutorial}
echo "Concourse API target ${fly_target}"

pushd $DIR
  fly -t ${fly_target} set-pipeline -p terraform -c terraform.yml -n
  fly -t ${fly_target} unpause-pipeline -p terraform
  fly -t ${fly_target} trigger-job -w -j terraform/terraform-build
popd

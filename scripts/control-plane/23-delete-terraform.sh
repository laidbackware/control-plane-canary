#!/bin/bash
set -eu

[ -z "${IAAS:-}" ] && echo '$IAAS must be set' && exit 2

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"

cleanup() {
  if [ -d "$temp_dir" ]; then
    rm -rf "$temp_dir"
  fi
}

trap cleanup EXIT

temp_dir="$(mktemp -d -p `pwd`)"

pushd "${repo_root}/terraform/${IAAS}/"
  terraform init
  terraform destroy -var-file="${repo_root}/vars/${IAAS}/terraform.tfvars" -state="${repo_root}/state/terraform.tfstate" --auto-approve
popd

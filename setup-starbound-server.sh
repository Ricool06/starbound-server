#!/usr/bin/env bash
set -eE

cd $(dirname "$0")
OLD_PWD="${PWD}"
SCRIPT_DIR=$(pwd)

function return_to_old_pwd {
  echo "Returning to working directory..."
  cd $OLD_PWD
}
trap return_to_old_pwd EXIT

cd "${SCRIPT_DIR}/configs/bootstrap_backend"
terraform init
terraform apply -auto-approve

cd "${SCRIPT_DIR}/configs/starbound_server"
terraform init
terraform apply -auto-approve

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_PRIVATE_KEY_FILE=$(terraform output temp_private_key_file)

ansible-playbook --user ubuntu --inventory $(terraform output public_ip), ./ansible/install-starbound-server.yml

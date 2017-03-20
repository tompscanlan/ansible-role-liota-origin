#!/bin/bash

# Copyright © 2017 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: MIT

set -e
set -x

containers=(
    "ansible/ansible:ubuntu1204"
    "tompscanlan/photon-ansible-base"
    "ansible/ansible:fedora24"
    "ansible/ansible:ubuntu1604"
    "ansible/ansible:opensuse42.2"
    "ansible/ansible:centos7"
    )
inits=(
    "/sbin/init"
    "/usr/lib/systemd/systemd"
    "/usr/lib/systemd/systemd"
    "/lib/systemd/systemd"
    "/usr/lib/systemd/systemd"
    "/usr/lib/systemd/systemd"
)
options=(
    ""
    "--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
    "--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
    "--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
    "--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
    "--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
)

cleanup() {
    echo "Failed tests on $container"

    docker kill "$(cat ${container_id})"
}

trap cleanup EXIT

for ((i=0;i<${#containers[@]};++i)); do

    container="${containers[i]}"
    init="${inits[i]}"
    option="${options[i]}"
    container_id=$(mktemp)

    docker run  --rm  -d $option -v "$PWD:/etc/ansible/roles/ansible-role-liota" "$container" "$init" > "${container_id}"

    docker exec "$(cat ${container_id})" bash -c 'pip install -U pip;'

    docker exec "$(cat ${container_id})" bash -c 'pip install ansible;'
    docker exec "$(cat ${container_id})" bash -c 'ansible-playbook /etc/ansible/roles/ansible-role-liota/tests/test.yml --syntax-check'
    docker exec "$(cat ${container_id})" bash -c 'ansible-playbook /etc/ansible/roles/ansible-role-liota/tests/test.yml;'
    docker kill "$(cat ${container_id})"
done

trap - EXIT


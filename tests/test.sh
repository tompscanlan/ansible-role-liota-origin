#!/bin/bash

set -e

containers="tompscanlan/photon-ansible-base ansible/ansible:fedora24 ansible/ansible:ubuntu1204 ansible/ansible:ubuntu1604 ansible/ansible:opensuse42.2 ansible/ansible:centos7"

cleanup() {
    echo "Failed tests on $container"

    docker kill $ID
}

trap cleanup EXIT

for container in $containers; do
    ID=$( docker run  --rm  -d -v "$PWD:/mnt" $container sleep 10000 )

    docker exec -it $ID bash -c 'pip install -U pip;'

    docker exec -it $ID bash -c '
        pip install ansible;
        ln -s /mnt /ansible-role-liota;
        cd /ansible-role-liota;
        printf '[defaults]\\\\nroles_path=/:../:.' >ansible.cfg ;
        ansible-playbook tests/test.yml -i tests/inventory --syntax-check &&
        ansible-playbook tests/test.yml -i tests/inventory'
    docker kill $ID
done

trap - EXIT


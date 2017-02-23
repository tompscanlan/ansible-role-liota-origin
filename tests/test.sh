#!/bin/bash
set -x
set -e
id=$( docker run  --rm  -d -v "$PWD:/mnt" ansible/ansible:ubuntu1204 sleep 10000 )

docker exec -it $id bash -c 'pip install -U pip;'

docker exec -it $id bash -c '
	pip install ansible;
	ln -s /mnt /ansible-role-liota;
	cd /ansible-role-liota;
	printf '[defaults]\\\\nroles_path=/:../:.' >ansible.cfg ;
	ansible-playbook tests/test.yml -i tests/inventory --syntax-check &&
	ansible-playbook tests/test.yml -i tests/inventory'
docker kill $id

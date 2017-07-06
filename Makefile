all:

build: ssh/ssh_host_rsa_key  ssh/id_rsa_ansible_test_node
	docker build -t eagafonov/test-ansible-node .

clean:
	-docker stop test-ansible-node
	-docker rm test-ansible-node

run-sshd: clean
	docker start test-ansible-node || \
	docker run --name test-ansible-node \
		-p 127.0.0.100:2222:22 \
		-ti \
		eagafonov/test-ansible-node \
		/bin/sh -c '/usr/sbin/sshd -D'

run: clean
	docker start test-ansible-node || \
	docker run --name test-ansible-node \
		-p 127.0.0.100:2222:22 \
		-ti \
		eagafonov/test-ansible-node

shell:
	docker exec -ti test-ansible-node /bin/bash

ssh-key-gen:
	

ssh/id_rsa_ansible_test_node:
	ssh-keygen -N "" -f $@

ssh/ssh_host_rsa_key:
	ssh-keygen -N "" -f $@


ssh-root:
	ssh -p 2222 -i ssh/id_rsa_ansible_test_node root@127.0.0.100

ssh-user:
	ssh -p 2222 -i ssh/id_rsa_ansible_test_node testuser@127.0.0.100

.PHONY: ssh
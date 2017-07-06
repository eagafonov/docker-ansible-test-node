FROM debian:wheezy
MAINTAINER e.a.agafonov@gmail.com

RUN apt-get update

RUN apt-get install -y --force-yes \
    openssh-server \
    python \
    sudo

# Put pre-existing SSH Host keys
ADD ssh/ssh_host_* /etc/ssh/
ADD ssh/id_rsa_ansible_test_node.pub /root/id_rsa_ansible_test_node.pub
ADD sudoers_testuser /etc/sudoers.d


RUN mkdir /root/.ssh \
    && cat /root/id_rsa_ansible_test_node.pub > /root/.ssh/authorized_keys \
    && adduser testuser \
    && usermod -a -G sudo testuser \
    && mkdir /home/testuser/.ssh \
    && cat /root/id_rsa_ansible_test_node.pub > /home/testuser/.ssh/authorized_keys \
    && mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd

CMD /bin/sh -c '/usr/sbin/sshd -D'
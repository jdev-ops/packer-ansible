
Release:

USER_ID=$(id -u) GROUP_ID=$(id -g) SSH_PATH=/home/a/.ssh SRC_PATH=/home/a/src/a/sb/dev/payment_services COMPILER_OS=centos7 ELIXIR_VERSION=19 ansible-playbook -v provision.yml

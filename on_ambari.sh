#!/bin/bash

set -e

targets=(hdfs-master hdfs-node1 hdfs-node2 ambari)

function copy_pub_key
{
    local host=$1

    cat ~/.ssh/id_rsa.pub | ssh $target "mkdir -p .ssh && cat > .ssh/authorized_keys"

}

function install_minimal_pkgs
{
    local host=$1

    ssh $host "sudo apt update && sudo apt -y install unzip python"

}

function add_ambari_repo_key
{
    local host=$1

    ssh $host "sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD"

}

function setup_ntp
{
    local host=$1

    ssh $host "sudo sh -c 'apt -y install ntp && update-rc.d ntp defaults'"

}

for target in ${targets[@]}; do
    copy_pub_key $target
    add_ambari_repo_key $target
    install_minimal_pkgs $target
    setup_ntp $target
done

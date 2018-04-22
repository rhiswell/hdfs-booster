#!/bin/bash
#
# Prepare some server (ubuntu 16.04 LTS) instances in local KVM-based system to 
# deploy a HDFS.
#

set -e

. config.sh

#SERVER=114
SERVER=730
IMG_DIR=/raid/workspace/qemu-kvm-imgs

function error_at
{
    echo
    echo "ERROR: $1"
    echo
    exit $?
}

function info_at
{
    echo
    echo "INFO: $1"
    echo
}

function warn_at
{
    echo
    echo "WARN: $1"
    echo
}

scp config.sh on_hypervisor.sh $SERVER: && ssh $SERVER "bash on_hypervisor.sh" && \
    info_at "images of VMs are ready on server" || \
    error_at "failed to gprepare images of VMs on server"

function new_instance
{
    local instance_id=$1
    local hostname=$2

    local this_img=$IMG_DIR/$instance_id.qcow2
    local this_cidata_iso=$IMG_DIR/$instance_id.cidata.iso

    virt-install \
        --connect qemu+ssh://$SERVER/system \
        --name $instance_id \
        --vcpus ${vcpucnt[$instance_id]} \
        --memory ${memorysize[$instance_id]} \
        --network network=default,model=virtio \
        --os-type=linux --os-variant=ubuntu16.04 \
        --virt-type kvm \
        --disk path=$this_img,bus=virtio --import \
        --disk path=$this_cidata_iso,device=cdrom \
        --noautoconsole && \
        info_at "successfully create instance $instance_id" || \
        error_at "failed to create instance $instance_id"
}

sudo apt install virt-manager && info_at "virt-manager is installed" || \
    error_at "failed to install virt-manager"

for instance_id in ${instance_ids[@]}; do
    new_instance $instance_id ${hostname[$instance_id]}
done


#!/bin/bash

set -e

. config.sh

IMG_URL=http://mirrors.ustc.edu.cn/ubuntu-cloud-images
IMG_URL=$IMG_URL/xenial/current/xenial-server-cloudimg-amd64-disk1.img

IMG_DIR=/raid/workspace/qemu-kvm-imgs
IMG_BASE=$IMG_DIR/u1604cloud_base.qcow2

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

sudo apt install qemu-kvm libvirt-bin genisoimage && \
    info_at "qemu-kvm libvirt-bin genisoimage are installed" || \
    error_at "failed to install required packages"
sudo systemctl enable libvirt-bin && sudo systemctl restart libvirt-bin && \
    info_at "libvirt-bin is enabled and started" || \
    error_at "failed to enable or start libvirt-bin"

function download_img_and_decompress
{
    test -e $IMG_DIR/u1604cloud.img || wget $IMG_URL -O $IMG_DIR/u1604cloud.img

    qemu-img convert -O qcow2 $IMG_DIR/u1604cloud.img $IMG_BASE || \
        error_at "failed to convert $IMG_DIR/u1604cloud.img"

    test -e $IMG_BASE && info_at "u1604cloud_base.qcow2 is created" || \
        error_at "failed to create u1604cloud_base.qcow2"
}

sudo mkdir -p $IMG_DIR && sudo chown $USER:$USER -R $IMG_DIR
test -e $IMG_BASE && info_at "$IMG_DIR/u1604cloud_base.qcow2 exists" \
    || download_img_and_decompress

function prepare_img()
{
    local instance_id=$1
    local hostname=$2

    local this_img=$IMG_DIR/$instance_id.qcow2
    local this_cidata_dir=$IMG_DIR/$instance_id-cidata

    mkdir -p $this_cidata_dir

    local this_metadata=$this_cidata_dir/meta-data
    local this_userdata=$this_cidata_dir/user-data
    local this_cidata_iso=$IMG_DIR/$instance_id.cidata.iso

    # metadata: intance_id & hostname & network & public-keys
    cat >$this_metadata <<EOF
instance-id: $instance_id
local-hostname: $hostname
EOF

    # userdata: password
    cat >$this_userdata <<EOF
#cloud-config
password: passw0rd
chpasswd: { expire: False }
ssh_pwauth: True
EOF

    genisoimage -o $this_cidata_iso -V cidata -r -J $this_cidata_dir

    qemu-img create -f qcow2 -b $IMG_BASE $this_img && \
        qemu-img resize $this_img ${disksize[$instance_id]} && qemu-img info $this_img && \
        info_at "$this_img is created"
}

for instance_id in ${instance_ids[@]}; do
    test -e $IMG_DIR/$instance_id.qcow2 && warn_at "$IMG_DIR/$instance_id.qcow2 exists" || \
        prepare_img $instance_id ${hostname[$instance_id]}
done

exit 0

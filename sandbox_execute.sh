#!/bin/bash

# Configuration
BASE_IMAGE="/var/lib/libvirt/images/windows10_base.qcow2"
OVERLAY_IMAGE="/var/lib/libvirt/images/analysis_overlay.qcow2"
VM_NAME="Malware_Lab_$(date +%s)"
SAMPLE_PATH="./malware_sample.exe"

# 1. Create the overlay file
# All writes go here; the base image remains untouched.
qemu-img create -f qcow2 -b "$BASE_IMAGE" -F qcow2 "$OVERLAY_IMAGE"

# 2. Inject the sample and commands (Offline)
# Use virt-customize to prep the disk before power-on
virt-customize -a "$OVERLAY_IMAGE" \
    --upload "$SAMPLE_PATH:/Users/Public/Desktop/sample.exe" \
    --run-command "echo 'start C:\Users\Public\Desktop\sample.exe' > C:\Users\Public\Desktop\run.bat"

# 3. Create and start the VM
virt-install \
    --name "$VM_NAME" \
    --memory 4096 \
    --vcpus 2 \
    --disk path="$OVERLAY_IMAGE",format=qcow2 \
    --import \
    --network network=isolated_malware_net \
    --noautoconsole

echo "VM $VM_NAME is running. Press any key to destroy it..."
read -n 1

# 4. Destroy and Cleanup
virsh destroy "$VM_NAME"
virsh undefine "$VM_NAME" --remove-all-storage
rm -f "$OVERLAY_IMAGE"

#!/bin/sh

##Remove default debian/ubuntu 
apt remove network-manager

###################
## Open Virtual Switch
#########################

## Install Open Virtual Switch packages
apt install openvswitch-common openvswitch-switch
ovs-vsctl add-br wan
ovs-vsctl add-br manage
ovs-vsctl add-br combat
ovs-vsctl add-br combat_ex1
ovs-vsctl add-br combat_ex2
ovs-vsctl add-br combat_wifi


## Attach physical ethernet card to the bridge - this attaches
ovs-vsctl add-port wan eno1
## To get an IP address from your WAN router 
dhclient wan

###################
## Build kvm Network :-)
#########################
virsh net-define << 'EOF' 
<network>
  <name>wan</name>
  <forward mode="bridge"/>
  <bridge name="wan" />
  <virtualport type="openvswitch" />
</network>
EOF

virsh net-define << 'EOF' 
<network>
  <name>manage</name>
  <forward mode="bridge"/>
  <bridge name="manage" />
  <virtualport type="openvswitch" />
</network>
EOF

virsh net-define << 'EOF' 
<network>
  <name>combat</name>
  <forward mode="bridge"/>
  <bridge name="combat" />
  <virtualport type="openvswitch" />
</network>
EOF

virsh net-define << 'EOF' 
<network>
  <name>combat_ex1</name>
  <forward mode="bridge"/>
  <bridge name="combat_ex1" />
  <virtualport type="openvswitch" />
</network>
EOF

virsh net-define << 'EOF' 
<network>
  <name>combat_ex2</name>
  <forward mode="bridge"/>
  <bridge name="combat_ex2" />
  <virtualport type="openvswitch" />
</network>
EOF

virsh net-define << 'EOF' 
<network>
  <name>combat_wifi</name>
  <forward mode="bridge"/>
  <bridge name="combat_wifi" />
  <virtualport type="openvswitch" />
</network>
EOF

###################
## Start virtual network :-)
#########################
virsh net-start wan
virsh net-start manage
virsh net-start combat
virsh net-start combat_ex1
virsh net-start combat_ex2
virsh net-start combat_wifi


## Create and install pfSense WAN firewall 
virt-install --name=pfwan.v2 \
  --boot cdrom,hd \
  --vcpus=2 \
  --memory=2048 \
  --network network=wan,model=virtio,target=pfwan_wan,mac=2E:22:22:22:22:22 \
  --network network=manage,model=virtio,target=pfwan_manage,mac=22:22:22:22:22:22 \
  --network network=combat,model=virtio,target=pfwan_combat,mac=26:22:22:22:22:22 \
  --disk /opt/kvm/domains/pfwan/pfsense.v2.img \
  --disk /opt/kvm/domains/pfwan/pfsense.v2.swap \
  --cdrom /opt/kvm/domains/ISO/pfsense.iso \
  --os-variant=freebsd8

## Create and install pfSense combat firewall 
virt-install --name=pfcombat.v2 \
  --boot cdrom,hd \
  --vcpus=2 \
  --memory=2048 \
  --network network=combat,model=virtio,target=pfcombat_combat,mac=46:44:44:44:44:44 \
  --network network=manage,model=virtio,target=pfcombat_manage,mac=42:44:44:44:44:44 \
  --network network=combat_ex1,model=virtio,target=pfcombat_ex1,mac=56:55:55:55:55:55 \
  --network network=combat_ex2,model=virtio,target=pfcombat_ex2,mac=66:66:66:66:66:66 \
  --network network=combat_wifi,model=virtio,target=pfcombat_wifi,mac=76:77:77:77:77:77 \
  --disk /opt/kvm/domains/pfcombat/pfsense.v2.img \
  --disk /opt/kvm/domains/pfcombat/pfsense.v2.swap \
  --cdrom /opt/kvm/domains/ISO/pfsense.iso \
  --os-variant=freebsd8


##Building Windows 10 from ISO image 

##Create a sparse file, notice the reported file sizes.
truncate -s 40G win10.img
ls -halF win10.img
du -h win10.img

virt-install \
    --name=windows10 \
    --ram=8192 \
    --cpu=host \
    --vcpus=2 \
    --os-type=windows \
    --disk /opt/kvm/domains/win10/win10.img \
    --disk /opt/kvm/domains/ISO/Win10_1809Oct_v2_English_x64.iso,device=cdrom,bus=ide \
    --disk /opt/kvm/domains/ISO/virtio-win-0.1.141.iso,device=cdrom,bus=ide \
    --network network=combat_ex1,model=virtio,driver=rtl8139,target=win10_combat_ex1,mac=B6:BB:BB:BB:BB:BB 
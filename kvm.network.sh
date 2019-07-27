#!/bin/bash
##apt-get remove networking-managaer

export OUT=out/

##Define vars for WAN,MANAGEMENT and COMBAT networks INTERFACES and BRIDGES.
export WAN_IF=eno1 
##export WAN_IF=wlx00c0ca61daa2 ##eth0,eno1,xn0,... etc.
export WAN_BR=wan

export MANAGE_IF=manage_if
export MANAGE_BR=manage
export COMBAT_IF=combat_if
export COMBAT_BR=combat
export COMBATEX1_BR=combat_ex1
export COMBATEX2_BR=combat_ex2
export COMBATEX3_BR=combat_ex3
export COMBATTOR_BR=combat_tor

##Special parameters for commands that called.
#export XARGS=-p
export XARGS=--no-run-if-empty

##WRITE a Linux network interface file locally.
cat << EOF > $OUT/interfaces.virtuallab

##############################################  
##PHYSICAL & DUMMY INTERFACES##
##############################################    
iface $WAN_IF inet static

iface $MANAGE_IF inet manual
  pre-up ip link add $MANAGE_IF type dummy
  post-down ip link del $MANAGE_IF type dummy

iface $COMBAT_IF inet manual
  pre-up ip link add $COMBAT_IF type dummy
  post-down ip link del $COMBAT_IF type dummy

##############################################  
##BRIDGE IPs / MACs
##############################################  
iface $WAN_BR inet dhcp
  hwaddress ether 06:00:00:00:00:00
  bridge_ports $WAN_IF

iface $MANAGE_BR inet manual
  hwaddress ether 16:11:11:11:11:11
  bridge_ports $MANAGE_IF

iface $COMBAT_BR inet manual
  hwaddress ether 66:66:66:66:66:66
  bridge_ports $COMBAT_IF

iface $COMBATEX1_BR inet manual
  bridge_ports $COMBAT_IF

iface $COMBATEX2_BR inet manual 
  bridge_ports $COMBAT_IF

iface $COMBATEX3_BR inet manual 
  bridge_ports $COMBAT_IF
  hwaddress ether 76:77:77:77:77:77

iface $COMBATTOR_BR inet manual 
  bridge_ports $COMBAT_IF
  hwaddress ether E6:EE:EE:EE:EE:EE
#######################################


#######################################
##Auto-start INTERFACES and BRIDGES
#######################################
auto $WAN_IF 
auto $WAN_BR

auto $MANAGE_IF 
auto $MANAGE_BR

auto $COMBAT_IF
auto $COMBAT_BR
auto $COMBATEX1_BR
auto $COMBATEX2_BR
auto $COMBATEX3_BR
auto $COMBATTOR_BR

EOF

cat << EOF > $OUT/wan.kvm
<network>
  <name>wan</name>
  <forward mode="bridge"/>
  <bridge name="$WAN_BR"/>
</network>
EOF

cat << EOF > $OUT/manage.kvm
<network>
  <name>manage</name>
  <forward mode="bridge"/>
  <bridge name="$MANAGE_BR"/>
</network>
EOF

cat << EOF > $OUT/combat.kvm
<network>
  <name>combat</name>
  <forward mode="bridge"/>
  <bridge name="$COMBAT_BR"/>
</network>
EOF

cat << EOF > $OUT/combat_ex1.kvm
<network>
  <name>combat_ex1</name>
  <forward mode="bridge"/>
  <bridge name="$COMBATEX1_BR"/>
</network>
EOF

cat << EOF > $OUT/combat_ex2.kvm
<network>
  <name>combat_ex2</name>
  <forward mode="bridge"/>
  <bridge name="$COMBATEX2_BR"/>
</network>
EOF

cat << EOF > $OUT/combat_ex3.kvm
<network>
  <name>combat_ex3</name>
  <forward mode="bridge"/>
  <bridge name="$COMBATEX3_BR"/>
</network>
EOF

cat << EOF > $OUT/combat_tor.kvm
<network>
  <name>combat_tor</name>
  <forward mode="bridge"/>
  <bridge name="$COMBATTOR_BR"/>
</network>
EOF

echo wan \
     manage \
     combat \
     combat_ex1 \
     combat_ex2 \
     combat_ex3 \
     combat_tor | xargs $XARGS -n 1 virsh net-destroy

echo wan \
     manage \
     combat \
     combat_ex1 \
     combat_ex2 \
     combat_ex3 \
     combat_tor | xargs $XARGS -n 1 virsh net-undefine

echo $OUT/wan.kvm \
     $OUT/manage.kvm \
     $OUT/combat.kvm \
     $OUT/combat_ex1.kvm \
     $OUT/combat_ex2.kvm \
     $OUT/combat_ex3.kvm \
     $OUT/combat_tor.kvm | xargs $XARGS -n 1 virsh net-define --file 

echo wan \
     manage \
     combat \
     combat_ex1 \
     combat_ex2 \
     combat_ex3 \
     combat_tor | xargs $XARGS -n 1 virsh net-autostart

echo wan \
     manage \
     combat \
     combat_ex1 \
     combat_ex2 \
     combat_ex3 \
     combat_tor | xargs $XARGS -n 1 virsh net-start

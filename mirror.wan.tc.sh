#!/bin/sh 

## Create a 'wan.mirror' dummy device to attach streaming services
## This example could create mirrors for combat and tor segments...
## Original influence: https://backreference.org/2014/06/17/port-mirroring-with-linux-bridges/

#Create a dummy device called wan.mirror 
ip link add wan.mirror type dummy

#Create ingres filter id "ffff:" (in)
tc qdisc add dev wan ingress

#Create egress filter id "1111:" (out)  
tc qdisc add dev wan handle 1111: root prio

## Turn on mirroring based on fileter id (ffff:,1111:=in,out) 
tc filter add dev wan parent ffff: \
    protocol all \
    u32 match u8 0 0 \
    action mirred egress mirror dev wan.mirror

tc filter add dev wan parent 1111: \
    protocol all \
    u32 match u8 0 0 \
    action mirred egress mirror dev wan.mirror

#Begin the mirroring to the wan.mirror dummy device
ip link set dev wan.mirror up

## To demonstrate your tap is working:
tcpdump -e -v -n -i wan.mirror 

##May need to delete docker who is sitting out 172.17.0.0/16 and we 172.16.0.0/12
#ip addr show dev docker0
#ip addr del 172.17.0.1/16 dev docker0
#ip addr add 172.16.0.1/12 dev manage

#ip addr add 10.0.0.1/8 dev combat

#dhclient wan

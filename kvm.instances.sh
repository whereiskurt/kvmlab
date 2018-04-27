virt-install --name=pfwan \
  --boot hd \
  --vcpus=1 \
  --memory=2048 \
  --network network=wan,mac=02:00:00:00:00:00 \
  --network network=manage \
  --network network=combat \
  --disk /opt/kvm/domains/pfwan/pfsense.img \
  --os-variant=freebsd8 

virt-install --name=pfcombat \
  --boot hd \
  --vcpus=1 \
  --memory=2048 \
  --network network=combat,mac=22:22:22:22:22:22 \
  --network network=combat_ex1 \
  --network network=combat_ex2 \
  --network network=combat_ex3 \
  --network network=combat_tor \
  --network network=manage \
  --disk /opt/kvm/domains/pfcombat/pfsense.img \
  --cdrom /opt/kvm/domains/ISO/pfsense.iso \
  --os-variant=freebsd8

virt-install --name=kali \
  --boot cdrom \
  --vcpus=4 \
  --memory=4096 \
  --network network=combat_ex1,mac=C2:CC:CC:CC:CC:CC \
  --disk /opt/kvm/domains/kali.attack/kali.img \
  --cdrom /opt/kvm/domains/kali.attack/kali.iso \
  --os-variant=debianwheezy

virt-install --name=win10k \
  --vcpus=4 \
  --memory=4096 \
  --network network=combat_ex2,mac=D2:DD:DD:DD:DD:DD \
  --disk /opt/kvm/domains/win10.preview/disk.img \
  --disk /opt/kvm/domains/ISO/win10.1709.iso,device=cdrom,bus=ide \
  --disk /opt/kvm/domains/ISO/virtio-win-0.1.141.iso,device=cdrom,bus=ide \
  --os-type=windows \
  --os-variant=win8.1 
 

virsh -c qemu:///system define /opt/kvm/domains/whonix/whonix.xml

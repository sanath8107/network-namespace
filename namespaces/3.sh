sudo ip netns add ns
sudo ip link add eth0 type veth peer name eth1
sudo ip link set eth0 netns ns
sudo ip link add br0 type bridge
sudo ip link set eno1 master br0
sudo ip link set eth1 master br0
sudo ip link set eno1 up
sudo ip link set eth1 up     
sudo ip link set br0 up
sudo ip netns exec ns dhclient eth0
sudo ip netns exec ns ping 10.10.54.4
sudo ip netns delete ns

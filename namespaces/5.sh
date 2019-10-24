#Creating two network namespaces
sudo ip netns add sanath
sudo ip netns add sanath1
#Creating veth pairs
sudo ip link add eth0 type veth peer name eth1
sudo ip link add eth2 type veth peer name eth3
#Setting the ends of the veth in the created namespaces
sudo ip link set eth0 netns sanath
sudo ip link set eth2 netns sanath1
#Bring up the interfaces within namespaces
sudo ip netns exec sanath ip link set eth0 up
sudo ip netns exec sanath1 ip link set eth2 up
#Assign ip addresses to the interfaces within the namespace
sudo ip netns exec sanath ip address add 10.0.0.1/24 dev eth0
sudo ip netns exec sanath1 ip address add 10.0.2.1/24 dev eth2
#Create router namespace and add appropriate interfaces into it
sudo ip netns add router
sudo ip link set eth1 netns router
sudo ip link set eth3 netns router
#Setting the interfaces up
sudo ip netns exec router ip link set eth1 up
sudo ip netns exec router ip link set eth3 up
#Assigning ip addresses to the interfaces within router
sudo ip netns exec router ip address add 10.0.0.2/24 dev eth1
sudo ip netns exec router ip address add 10.0.2.2/24 dev eth3
#Bringing the loopback interface up
sudo ip netns exec sanath ip link set lo up
sudo ip netns exec sanath1 ip link set lo up
sudo ip netns exec router ip link set lo up
#Adding a default gateway
sudo ip netns exec sanath ip route add default via 10.0.0.2 dev eth0
sudo ip netns exec sanath1 ip route add default via 10.0.2.2 dev eth2
#Enable IP forwarding : Make it act as a router
sudo ip netns exec router sysctl -w net.ipv4.ip_forward=1
#Pinging the interface in neeru from neeru1
sudo ip netns exec sanath1 ping 10.0.0.1
#Deleting the namespaces
sudo ip netns delete sanath
sudo ip netns delete sanath1
sudo ip netns delete router

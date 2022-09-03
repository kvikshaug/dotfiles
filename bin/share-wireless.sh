ETHDEV=enp0s31f6
WLANDEV=wlan0

if [ "$1" = "undo" ]; then
  echo "share-wireless: undoing 192.168.13.37/24"
  sudo sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"
  sudo ip addr del 192.168.13.37/24 dev ${ETHDEV}
  sudo iptables -t nat -D POSTROUTING -o ${WLANDEV} -j MASQUERADE
  sudo iptables -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  sudo iptables -D FORWARD -i ${ETHDEV} -o ${WLANDEV} -j ACCEPT
  sudo systemctl stop dhcpd4.service
  echo "share-wireless: done"
else
  echo "share-wireless: configuring 192.168.13.37/24"
  sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
  sudo ip link set up dev ${ETHDEV}
  sudo ip addr add 192.168.13.37/24 dev ${ETHDEV}
  sudo iptables -t nat -A POSTROUTING -o ${WLANDEV} -j MASQUERADE
  sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  sudo iptables -A FORWARD -i ${ETHDEV} -o ${WLANDEV} -j ACCEPT
  sudo systemctl start dhcpd4.service
  echo "share-wireless: done"
fi

# /etc/dhcpd.conf:
# option domain-name-servers 8.8.8.8, 8.8.4.4;
# option subnet-mask 255.255.255.0;
# option routers 192.168.13.37;
# subnet 192.168.13.0 netmask 255.255.255.0 {
#   range 192.168.13.100 192.168.13.200;
# }

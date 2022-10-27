#!/bin/bash
##conectando a rede interna via bridge
auto lo
auto interface

iface interface inet dhcp
auto interface

## 
iface interface inet static 
address 192.168.56.05
netmask 255.255.255.0
gateway 192.168.56.200


#limpando a  chains
iptables -F 
iptables -t nat -F

#PROTGE O FIREWALL#
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#stateful
iptables -I INPUT-mstate --state ESTABLISHED,RELATED -j  ACCEPT
iptables -I OUTPUT -mstate --state ESTABLISHED,RELATED -j ACCEPT
iptables -I FORWARD -mstate --state ESTABLISHED,RELATED -j ACCEPT

##permitindo ssh
iptables -A INPUT -p tcp --dport 22 -s maquinadoprof -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -d maquinadoprof -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 192.168.56.0 -j ACCEPT
iptables -A OUTPUT -p tcp- -sport 22 -s 192.168.56.0 -j ACCEPT

#acesso rede interna pelo nat
iptables -t nat -A PREROUTING -s 192.168.56.0/24 -o interface -j MASQUERADE

#liberando rede interna para os servicos
iptables -A FORWARD -p tcp -m multiport --dports 22 -s 192.168.56.0/24 -d 80,21,25,143 -j ACCEPT

##liberando pacote icmp
iptables -A INPUT -p icmp -s 192.168.56.05 -j ACCEPT 
iptables -A OUTPUT -p icmp -s 192.168.56.05 -j ACCEPT

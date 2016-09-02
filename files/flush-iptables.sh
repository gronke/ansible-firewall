#!/bin/sh

# Temporary set all policies to ACCEPT
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT

# Clear and Reset to Defaults
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t mangle -P PREROUTING ACCEPT
iptables -t mangle -P OUTPUT ACCEPT
ip6tables -t nat -P PREROUTING ACCEPT
ip6tables -t nat -P POSTROUTING ACCEPT
ip6tables -t nat -P OUTPUT ACCEPT
ip6tables -t mangle -P PREROUTING ACCEPT
ip6tables -t mangle -P OUTPUT ACCEPT

# Flush all rules
iptables -F
iptables -t nat -F
iptables -t mangle -F
ip6tables -F
ip6tables -t nat -F
ip6tables -t mangle -F

# Erease all non-default chains
iptables -X
iptables -t nat -X
iptables -t mangle -X
ip6tables -X
ip6tables -t nat -X
ip6tables -t mangle -X

# Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -d 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -s 127.0.0.1 -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A INPUT -s ::1 -d ::1 -j ACCEPT
ip6tables -A OUTPUT -s ::1 -d ::1 -j ACCEPT

# Established, Related
iptables -A INPUT -p ALL -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p ALL -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -p ALL -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -p ALL -m state --state ESTABLISHED,RELATED -j ACCEPT

# DROP --rt-type 0
ip6tables -A INPUT -m rt --rt-type 0 -j DROP
ip6tables -A OUTPUT -m rt --rt-type 0 -j DROP
ip6tables -A FORWARD -m rt --rt-type 0 -j DROP

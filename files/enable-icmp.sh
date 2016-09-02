#!/bin/bash

# Allow outgoing ICMP
# ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

# Allow RFC 4890 but with rate-limiting
for icmptype in 1 2 3/0 3/1 4/0 4/1 4/2 130 131 132 141 142 143 148 149 151 152
do
  ip6tables -A INPUT -p icmpv6 --icmpv6-type $icmptype -m limit --limit 900/min -j ACCEPT
  ip6tables -A OUTPUT -p icmpv6 --icmpv6-type $icmptype -m limit --limit 900/min -j ACCEPT
done

# Allow router advertisements on local network segments
for icmptype in 133 134 135 136 137
do
  ip6tables -A INPUT -p icmpv6 --icmpv6-type $icmptype -m hl --hl-eq 255 -j ACCEPT
  ip6tables -A OUTPUT -p icmpv6 --icmpv6-type $icmptype -m hl --hl-eq 255 -j ACCEPT
done

# Mobile prefix discovery requests
for icmptype in 144 146
do
  ip6tables -A OUTPUT -p icmpv6 --icmpv6-type $icmptype -m limit --limit 900/min -j ACCEPT
done

# Mobile prefix discovery replies
for icmptype in 145 147
do
  ip6tables -A INPUT -p icmpv6 --icmpv6-type $icmptype -m limit --limit 900/min -j ACCEPT
done

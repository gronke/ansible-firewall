ansible-firewall
================

Simple iptables wrapper role to harden microservices.

### firewall_rules
A list of firewall rules.

| Parameter     | Required  | Default       | Options                                 |
| ------------- | --------- | ------------- | ----------------------------------------|
| chain         | *yes*     |               | - INPUT<br>- OUTPUT<br>- FORWARD        |
| protocols     | no        | [tcp, udp]    | - tcp<br>- udp                          |
| ip_versions   | no        | [IPv4, IPv6]  | - IPv4<br>- IPv6                        |
| action        | no        | `ACCEPT`      | - ACCEPT<br>- DROP<br>- REJECT          |


### firewall_policies
Policies define the default behaviour when no `firewall_rules` apply to the network traffic. Only outgoing traffic can pass by default 
```yaml
firewall_policies:
  input: DROP
  output: ACCEPT
  forward: DROP
```

### firewall_allow_ping
The firewall is configured to respond to ICMP/Ping packets by default. Set this value to not explicitly allow ping (see [firewall_policies](#firewall_policies))

### firewall_rules_upload_dir
Remote (temporary) directory to upload the compiled firewall rules to. Expects a string with the absolute directory path that is automatically created and owned by the root user.

Install
-------
This role can be pulled as git submodule in an existing Ansible Playbook repository
```bash
git submodule add https://github.com/gronke/ansible-firewall.git roles/gronke.firewall
```

Examples
--------

### Standard Webserver firewall configuration
```yaml
- role: firewall
  firewall_rules:
    - chain: INPUT
      protocols:
        - tcp
      ports:
        - 80
        - 443
```

### Allow incoming traffic on port 80 via IPv4 only
```yaml
- role: firewall
  firewall_rules:
    - chain: INPUT
      ip_versions:
        - IPv6
      protocols:
        - tcp
      ports:
        - 80
        - 443
```

### Allow incoming traffic on all ports except 25
```yaml
- role: firewall
  firewall_policies:
    input: ACCEPT
    output: ACCEPT
    forward: DROP
  firewall_rules:
    - chain: INPUT
      ports:
        - 25
      action: DROP
```
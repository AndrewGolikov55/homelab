# Ansible collection: astra.ald_pro

This repo hosts the `astra.ald_pro` Ansible Collection.

The collection includes roles to help the deployment and management of ALD PRO controllers/clients.

## Requirements

### Ansible requirements

- `ansible` ">=2.10.2, <2.14"

## Roles
| Name                       | Description                                                       |
|----------------------------|-------------------------------------------------------------------|
| ` astra.ald_pro.controller` | Ansible role for deployment of ALD PRO controller                 |
| ` astra.ald_pro.client`     | Ansible role for deployment of ALD PRO client                     |

## Roles Variables

## Common variables

| Variable                   | Comment                                      | Required | Example/Default      |
|:---------------------------|----------------------------------------------|:--------:|----------------------|
| `aldpro_domain`            | ALD Pro domain name                          | yes      | `aldpro.local`       |
| `aldpro_admin_password`    | ALD Pro admin password                       | yes      | `g@sRR4UEQPY`        |
| `aldpro_version`           | ALD Pro version                              | no       | `1.4.1`              |
| `aldpro_extended_version`  | ALD Pro extended repository version          | no       | `generic`            |
| `aldpro_repo`              | ALD Pro debian repositories                  | no       | `deb https://artifactory.astralinux.ru/artifactory/aldpro-main {{ aldpro_version }} main`|

## astra.ald_pro.controller variables

| Variable                          | Comment                                      | Required | Example/Default      |
|:----------------------------------|----------------------------------------------|:--------:|----------------------|
| `aldpro_global_forwarders`        | ALD Pro Global DNS forwarders                | no       | `8.8.8.8`, `8.8.4.4` |
| `aldpro_server_minimal_memory_mb` | ALD Pro server minimum ram  requirements     | no       | `4096`               |

## astra.ald_pro.client variables

| Variable                   | Comment                                      | Required | Example/Default      |
|:---------------------------|----------------------------------------------|:--------:|----------------------|
| `aldpro_pdc_ip`            | ALD Pro domain controller IPv4               | yes      | `192.168.56.10`      |
| `aldpro_pdc_name`          | ALD Pro domain controller name               | yes      | `dc01`               |


## Dependencies

- Ansible galaxy collection `freeipa.ansible_freeipa` == 1.10.0

## Installing the collection

Include a collection in `requirements.yml` file:

```yaml
---
collections:
  - name: astra.ald_pro
    source: git+ssh://git@git.astralinux.ru:7999/arfa/ald_pro
    type: git
```

Install the collection using the command: `ansible-galaxy collection install -r requirements.yml`.


## Example Playbook

```YAML
- hosts: server
  become: true
  roles:
    - astra.ald_pro.controller

- hosts: clients
  become: true
  roles:
    - astra.ald_pro.client
```

## Testing

```Bash
$task test
```

## Known Issues

As ALD Pro uses FreeIPA version >= 4.8.2, by default, bind DNS server (which comes with FreeIPA) allows DNS recursive queries only for trusted networks. By default, trusted network list de facto contains only subnet of the domain controller itself.

Example of the `/etc/bind/ipa-ext.conf` configuration file (part):

```
* Example: ACL for recursion access:

acl "trusted_network" {
  localnets;
  localhost;
  234.234.234.0/24;
  2001::co:ffee:babe:1/48;
};
```

Example of the `/etc/bind/ipa-options-ext.conf` configuration file (part):

```
allow-recursion { trusted_network; };
```

To use this Ansible role in situations where domain clients are located in subnets that are different from the subnet of the main server, any host is permitted to send recursive queries which can be classified as security issue.

Example of the modified `/etc/bind/ipa-options-ext.conf` configuration file (part):

```
allow-recursion { any; };
```

Please, keep this in mind while using in Production environmets.

Useful links:
* https://www.freeipa.org/page/Releases/4.8.2#Resolved_tickets [8079]
* https://pagure.io/freeipa/issue/8079

### Idempotency

* astra.ald_pro.client aldpro-client-installer failure if client already in domain
* astra.ald_pro.controller changed > 0

## License

Apache 2.0

## Author Information

LLC "RusBITech-ASTRA"

## Supported OS

* Astra Linux Special Edition 1.7.3 Security level - Max ("Smolensk") ALD Pro version 1.4.0, 1.4.1
* Astra Linux Special Edition 1.7.2 Security level - Max ("Smolensk") ALD Pro versions 1.2.0, 1.2.1, 1.3.0, 1.4.0, 1.4.1

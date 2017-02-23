# ansible-role-liota

Install and manage Liota (Little Internet Of Things Agent)

## Requirements

Must have pip installed.

## Role Variables

Check [vars/default.yml](vars/default.yml) for details on available vars.

## Example Playbook

```yaml

---
- name: Install Liota From github
  hosts: liota
  roles:
    - liota
  vars:
    liota_pip_extra_args: -U

    liota_github_url: git+https://github.com/tompscanlan/liota.git
    liota_github_branch: systemd-units
    liota_version: github

- name: Install Liota public package
  hosts: liota
  roles:
    - liota
  vars:
    liota_pip_extra_args: -U
    liota_version: 0.2

- name: Uninstall and Install Liota various ways
  hosts: liota
  roles:
    - { role: liota, liota_state: absent }
    - { role: liota, liota_version: 0.2 }
    - { role: liota, liota_state: absent }
    - liota
  vars:
    liota_github_url: git+https://github.com/tompscanlan/liota.git
    liota_github_branch: systemd-units
    liota_version: github

```

## License

Copyright © 2017 VMware, Inc. All Rights Reserved.
SPDX-License-Identifier: MIT


## Author Information

Tom Scanlan
tscanlan@vmware.com
tompscanlan@gmail.com

pythian.openjdk_java for Ansible Galaxy
============

## Summary

This Ansible role has the following features for Open JDK:

 - Install JDK 8 version

## Role Variables

### Mandatory variables

None.

### Optional variables

User-configurable defaults:

```yaml
# which version?

java_packages: 
  - "java-1.8.0-openjdk"
  - "java-1.8.0-openjdk-devel"
  - "java-1.8.0-openjdk-headless"
```

## Usage

### Step 1: add role

Add role name `pythian.openjdk_java` to your playbook file.

### Step 2: add variables

Set vars in your playbook file.

Simple example:

```yaml
---
# file: simple-playbook.yml

- hosts: all

  roles:
    - pythian.openjdk_java
```

## Dependencies

## License

Licensed under the Apache License V2.0. See the [LICENSE file](LICENSE) for details.

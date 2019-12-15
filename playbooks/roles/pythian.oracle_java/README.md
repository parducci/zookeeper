pythian.oracle_java
============

## Summary

This Ansible role has the following features for Oracle JDK:

 - Install JDK 8 version
 - Install optional Java Cryptography Extensions (JCE)

## Role Variables

### Mandatory variables

None.

### Optional variables

User-configurable defaults:

```yaml
# which version?
java_version: 8

# which subversion?
java_subversion: 181

# SHA-256 checksum of JDK tar.gz file. Checked only when a value is supplied.
java_jdk_checksum:

# which directory to put the download file?
java_download_path: /tmp

# rpm/tar.gz file location:
#   - true: download from Oracle on-the-fly;
#   - false: copy from `{{ playbook_dir }}/files` on the control machine.
java_download_from_oracle: true

# remove temporary downloaded files?
java_remove_download: true

# set $JAVA_HOME?
java_set_javahome: false

# install JCE?
java_install_jce: false
```

For other configurable internals, read `tasks/set_role_variables.yml` file; for example, supported `java_version`/`java_subversion` combinations.

If you want to install a Java release which is not supported out-of-the-box, you have to specify the corresponding Java build number in the variable `java_build` in addition to `java_version` and `java_subversion`, e.g.
```yaml
---
- hosts: all

  roles:
    - pythian.oracle_java

  vars:
    java_version: 8
    java_subversion: 181
    java_build: 13
    java_url_modifier: 96a7b8442fe848ef90c96a2fad6ed6d1
    java_jdk_checksum: 1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3
```

### Customized variables, if absolutely necessary

If you have a pre-downloaded `jdk_tarball_file` whose filename cannot be inferred successfully by `tasks/set_role_variables.yml`, you may specify it explicitly: 

```yaml
# Specify the pre-fetch filename (without tailing .tar.gz or .rpm or .dmg);
# used in conjunction with `java_download_from_oracle: false`.

jdk_tarball_file

# For example, if you have a `files/jdk-7u79-linux-x64.tar.gz` locally,
# but the filename cannot be inferred successfully by `tasks/set_role_variables.yml`,
# you may specify the following variables in your playbook:
#
#    java_version:    7
#    java_subversion: 79
#    java_download_from_oracle: false
#    jdk_tarball_file: jdk-7u79-linux-x64
#
```

## Usage

### Step 1: add role

Add role name `pythian.oracle_java` to your playbook file.

### Step 2: add variables

Set vars in your playbook file.

Simple example:

```yaml
---
# file: simple-playbook.yml

- hosts: all

  roles:
    - pythian.oracle_java

  vars:
    java_version: 8
    java_subversion: 181
```


### (Optionally) pre-fetch .tar.gz files

For some reasons, you may want to pre-fetch .tar.gz files *before the execution of this role*, instead of downloading from Oracle on-the-fly.

To do this, put the file on the `{{ playbook_dir }}/files` directory in advance, and then set the `java_download_from_oracle` variable to `false`:

```yaml
---
# file: prefetch-playbook.yml

- hosts: all

  roles:
    - pythian.oracle_java

  vars:
    java_version: 8
    java_subversion: 181
    java_download_from_oracle: false
```

## Dependencies

## License

Licensed under the Apache License V2.0. See the [LICENSE file](LICENSE) for details.

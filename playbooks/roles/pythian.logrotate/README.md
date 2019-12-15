pythian.logrotate
=========

An Ansible role that installs and configures logrotate.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    logrotate_logrotated_files:
      - filename: "rsyslog"
        content: |
          /var/log/syslog
          {
            rotate 30
            daily
            missingok
            notifempty
            delaycompress
            compress
            postrotate
              invoke-rc.d rsyslog rotate > /dev/null
            endscript
          }

          /var/log/mail.info
          /var/log/mail.warn
          /var/log/mail.err
          /var/log/mail.log
          /var/log/daemon.log
          /var/log/kern.log
          /var/log/auth.log
          /var/log/user.log
          /var/log/lpr.log
          /var/log/cron.log
          /var/log/debug
          /var/log/messages
          {
            rotate 4
            weekly
            missingok
            notifempty
            compress
            delaycompress
            sharedscripts
            postrotate
              invoke-rc.d rsyslog rotate > /dev/null
            endscript
          }

List of logrotate files, specified as list of hashes in format {"filename": "", "content": ""}.
The value specified for "filename" will result in a file being created under /etc/logrotate.d/
of the same name. E.g. If "filename": "rsyslog", then file "/etc/logrotate.d/rsyslog" will be created.
The content of the file will be equal to the value of the string passed to "content".
Tip: Use the YAML '|' multiline string character when specifying the content of a file.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: pythian.logrotate }

License
-------

MIT / BSD

Author Information
------------------

Pythian

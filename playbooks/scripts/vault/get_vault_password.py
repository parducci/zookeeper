#!/usr/bin/env python

##############################################################
# Description  | Executable script to get Ansible vault      #
#              | password from VAULT_PASSWORD environment    #
#              | variable. The purpose of this script is to  #
#              | provide a way to supply the vault password  #
#              | via environment variable instead of only    #
#              | password file. This script may be used to   #
#              | guard against mistakenly checking in the    #
#              | vault password file into the repo.          #
#------------------------------------------------------------#
# Author       | Rory Bramwell <bramwell@pythian.com>        #
#------------------------------------------------------------#
# Created      | March 28, 2017                              #
#------------------------------------------------------------#
# Last updated | March 29, 2017                              #
##############################################################

import sys
import os

vault_password = os.environ.get('VAULT_PASSWORD')
if vault_password != None:
  print vault_password
else:
  sys.stderr.write("ERROR: Environment variable 'VAULT_PASSWORD' was not found.\n")
  raise KeyError

#!/bin/bash

##############################################################
# Description  | List available ansiblespec rake tasks.      #
#------------------------------------------------------------#
# Author       | Rory Bramwell <bramwell@pythian.com>        #
#------------------------------------------------------------#
# Created      | Feb 16, 2017                                #
#------------------------------------------------------------#
# Last updated | Feb 16, 2017                                #
##############################################################

# Requires ansible_spec v0.2.20+ ruby gem.

# Help function
function display_help {
  echo "rake_list_ansiblespec_tasks.sh [-i|--inventory|-p|-playbook|-d|--vars-dirs-path|-s|--ssh-config-file|-h|--help]"
  echo ""
  echo "   List available ansiblespec rake tasks."
  echo ""
  echo "   Options:"
  echo "     -i|--inventory        Path to the inventory file with target hosts."
  echo "     -p|--playbook         Playbook to check/test against target hosts."
  echo "     -d|--vars-dirs-path   Directory path containing the group_vars and host_vars directories."
  echo "                           If not specified, defaults to the directory the script is executing from."
  echo "     -s|--ssh-config-file  SSH config file path."
  echo "     -h|--help             Display this help message."
  echo ""
  echo "   Example:"
  echo "     rake_list_ansiblespec_tasks.sh \ "
  echo "       --inventory=inventories/vagrant/hosts \ "
  echo "       --playbook=setup-ansible-automation-servers.yml \ "
  echo "       --vars-dirs-path=inventories/vagrant"
  echo ""
}

# Set initial values for variables
INVENTORY=''
PLAYBOOK=''
VARS_DIRS_PATH=''
SSH_CONFIG_FILE=''
HELP='false'

# Extract options and their arguments into variables.
while :; do
    case $1 in
        -h|-\?|--help)
            HELP='true'
            shift
            ;;
        -i|--inventory)       # Takes an option argument, ensuring it has been specified.
            INVENTORY="$2"
            shift
            ;;
        --inventory=?*)
            INVENTORY="${1#*=}" # Delete everything up to "=" and assign the remainder.
            ;;
        -p|--playbook)       # Takes an option argument, ensuring it has been specified.
            PLAYBOOK="$2"
            shift
            ;;
        --playbook=?*)
            PLAYBOOK="${1#*=}" # Delete everything up to "=" and assign the remainder.
            ;;
        -d|--vars-dirs-path)       # Takes an option argument, ensuring it has been specified.
            VARS_DIRS_PATH="$2"
            shift
            ;;
        --vars-dirs-path=?*)
            VARS_DIRS_PATH="${1#*=}" # Delete everything up to "=" and assign the remainder.
            ;;
        -s|--ssh-config-file)       # Takes an option argument, ensuring it has been specified.
            SSH_CONFIG_FILE="$2"
            shift
            ;;
        --ssh-config-file=?*)
            SSH_CONFIG_FILE="${1#*=}" # Delete everything up to "=" and assign the remainder.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

# Validate paramter values
if [[ -z "$INVENTORY" ]] && [[ "$HELP" != "true" ]]
then
  echo "ERROR: Required value missing - Must specify an inventory file."
  display_help
  exit 1
fi

if [[ -z "$PLAYBOOK" ]] && [[ "$HELP" != "true" ]]
then
  echo "ERROR: Required value missing - Must specify a playbook file."
  display_help
  exit 1
fi

if [[ -z "$VARS_DIRS_PATH" ]] && [[ "$HELP" != "true" ]]
then
  # Default to no explicit path
  VARS_DIRS_PATH=''
fi

if [[ "$HELP" == "true" ]]
then
  if [[ -n "$INVENTORY" ]] || [[ -n "$PLAYBOOK" ]] || [[ -n "$SSH_CONFIG_FILE" ]]
  then
    echo "ERROR: Additional flag(s) supplied with HELP flag."
    display_help
    exit 1
  else
    display_help
    exit 0
  fi
fi

# Get list of available rake tasks
if [[ -n "$SSH_CONFIG_FILE" ]]
then
  INVENTORY="$INVENTORY" \
  PLAYBOOK="$PLAYBOOK" \
  VARS_DIRS_PATH="$VARS_DIRS_PATH" \
  SSH_CONFIG_FILE="$SSH_CONFIG_FILE" \
  rake -T
else
  INVENTORY="$INVENTORY" \
  PLAYBOOK="$PLAYBOOK" \
  VARS_DIRS_PATH="$VARS_DIRS_PATH" \
  rake -T
fi

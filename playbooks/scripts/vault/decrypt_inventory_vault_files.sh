#!/bin/bash

###############################################################
# Description  | Ansible vault decrypt all group_vars/*/vault #
#              | and host_vars/*/vault files in all Ansible   #
#              | multi-staged environment inventories.        #
#              | This script must be run from the project     #
#              | root directory where the "inventories"       #
#              | directory is located directory.              #
#-------------------------------------------------------------#
# Author       | Rory Bramwell <bramwell@pythian.com>         #
#-------------------------------------------------------------#
# Created      | March 28, 2017                               #
#-------------------------------------------------------------#
# Last updated | April 11, 2017                               #
###############################################################

# Help function
function display_help {
  echo "decrypt_inventory_vault_files.sh [-i|--inventory-dir-name|-d|--project-dir-path|-h|--help]"
  echo ""
  echo "   Ansible vault encryt files named 'vault' in multi-staged environment inventory directories."
  echo ""
  echo "   Options:"
  echo "     -i|--inventory-dir-name  Name of the inventory directory under 'inventories/'."
  echo "                              e.g. 'staging'. Specify '*' to decrypt 'vault' files"
  echo "                              in all inventory directories."
  echo "     -d|--project-dir-path    Project base/root directory path where the"
  echo "                              'inventories' directory is located."
  echo "                              Default is '.' for current directory."
  echo "     -h|--help                Display this help message."
  echo ""
  echo "   Note: This script uses the 'get_vault_password.py' script to retreive the vault decryption"
  echo "         password from the 'VAULT_PASSWORD' environment variable."
  echo ""
  echo "   Example:"
  echo "     export VAULT_PASSWORD='somePass@123'"
  echo "     decrypt_inventory_vault_files.sh \ "
  echo "       --inventory-dir-name=staging \ "
  echo "       --project-dir-path=/home/myuser/playbooks_proj/"
  echo ""
}

# Set initial values for variables
INVENTORY_DIR_NAME=''
PROJECT_DIR_PATH=''
HELP='false'

# Extract options and their arguments into variables.
while :; do
    case $1 in
        -h|-\?|--help)
            HELP='true'
            shift
            ;;
        -i|--inventory-dir-name)           # Takes an option argument, ensuring it has been specified.
            INVENTORY_DIR_NAME="$2"
            shift
            ;;
        --inventory-dir-name=?*)
            INVENTORY_DIR_NAME="${1#*=}"   # Delete everything up to "=" and assign the remainder.
            ;;
        -d|--project-dir-path)             # Takes an option argument, ensuring it has been specified.
            PROJECT_DIR_PATH="$2"
            shift
            ;;
        --project-dir-path=?*)
            PROJECT_DIR_PATH="${1#*=}"     # Delete everything up to "=" and assign the remainder.
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
if [[ -z "$INVENTORY_DIR_NAME" ]] && [[ "$HELP" != "true" ]]
then
  echo "ERROR: Required value missing - Must specify an inventory directory name."
  display_help
  exit 1
fi

if [[ -z "$PROJECT_DIR_PATH" ]] && [[ "$HELP" != "true" ]]
then
  # Set default value as current directory
  PROJECT_DIR_PATH='.'
fi

if [[ "$HELP" == "true" ]]
then
  if [[ -n "$INVENTORY_DIR_NAME" ]] || [[ -n "$PROJECT_DIR_PATH" ]]
  then
    echo "ERROR: Additional flag(s) supplied with HELP flag."
    display_help
    exit 1
  else
    display_help
    exit 0
  fi
fi

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Recursively find all 'vault' files under the 'inventories' directory
declare -a VAULT_FILES=($(find $PROJECT_DIR_PATH/inventories/$INVENTORY_DIR_NAME/*_vars/* -type f -name 'vault'))

# Decrypt the vault files
for VFILE in "${VAULT_FILES[@]}"; do
  echo "Ansible vault decrypting file '$VFILE'"

  # Vault decrypt the current "vault" file
  TEMP_FILE=$(mktemp)
  # Decrypt file and messages. Note: All output is sent to stderr.
  ansible-vault decrypt "$VFILE" --vault-password-file "$SCRIPT_DIR/get_vault_password.py" 2> "$TEMP_FILE"
  RETURN_CODE=$?
  RETURN_TEXT_STDERR=$(cat "$TEMP_FILE")
  rm "$TEMP_FILE"

  # Successfully decrypted
  if [[ "$RETURN_TEXT_STDERR" == "Decryption successful" ]]
  then
    echo "Decryption successful"
    continue
  fi

  # Already decrypted
  if [[ "$RETURN_TEXT_STDERR" =~ "input is already decrypted" ]] || [[ $RETURN_CODE -eq 1 ]]
  then
    echo "Input is already decrypted"
    continue
  fi

  # Unknown error
  if [[ $RETURN_CODE -ne 0 ]]
  then
    echo "ERROR: An unexpected error has occurred (exit code: $RETURN_CODE)." >&2
    exit $RETURN_CODE
  fi

done

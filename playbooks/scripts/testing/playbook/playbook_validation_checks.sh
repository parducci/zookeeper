#!/bin/bash

##############################################################
# Description  | Perform validation checks on a playbook.    #
#------------------------------------------------------------#
# Author       | Rory Bramwell <bramwell@pythian.com>        #
#------------------------------------------------------------#
# Created      | Feb 14, 2017                                #
#------------------------------------------------------------#
# Last updated | August 16, 2017                             #
##############################################################

# Help function
function display_help {
  echo "playbook_validation_checks.sh [-i|--inventory|-p|-playbook]"
  echo ""
  echo "   Perform validation checks on a playbook."
  echo ""
  echo "   Options:"
  echo "     -i|--inventory  Path to the inventory file with target hosts."
  echo "     -p|--playbook   Playbook to check/test against target hosts."
  echo "     -l|--limit      Specify the host, group or @/path/to/file to target."
  echo "     -h|--help       Display this help message."
  echo ""
}

# Set initial values for variables
INVENTORY=''
PLAYBOOK=''
TARGETED_HOSTS=''
HELP='false'

# Read the options
OPTS=`getopt -o i:p:l:h --long inventory:,playbook:,limit:,help -n 'playbook_validation_checks.sh' -- "$@"`

if [ $? != 0 ] ; then echo "ERROR: Invalid option detected." >&2 ; display_help; exit 1 ; fi

eval set -- "$OPTS"

# Extract options and their arguments into variables.
while true ; do
    case "$1" in
        -i|--inventory)
            case "$2" in
                *) INVENTORY=$2 ; shift 2 ;;
            esac ;;
        -p|--playbook)
            case "$2" in
                *) PLAYBOOK=$2 ; shift 2 ;;
            esac ;;
        -l|--limit)
            case "$2" in
                *) TARGETED_HOSTS=$2 ; shift 2 ;;
            esac ;;
        -h|--help) HELP='true' ; shift ;;
        --) shift ; break ;;
        *) echo "ERROR: Internal error!" ; exit 1 ;;
    esac
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

if [[ -z "$TARGETED_HOSTS" ]] && [[ "$HELP" != "true" ]]
then
  # If not specified, set default value
  TARGETED_HOSTS='all'
fi

if [[ "$HELP" == "true" ]]
then
  if [[ -n "$INVENTORY" ]] || [[ -n "$PLAYBOOK" ]]
  then
    echo "ERROR: Additional flag(s) supplied with HELP flag."
    display_help
    exit 1
  else
    display_help
    exit 0
  fi
fi

# Perform validation checks
echo ""
echo "*********************************"
echo "*** PERFORM VALIDATION CHECKS ***"
echo "*********************************"
echo ""

echo ""
echo "------------------------"
echo "- Running syntax check -"
echo "------------------------"
echo ""

ansible-playbook --syntax-check -i "$INVENTORY" "$PLAYBOOK" --limit "$TARGETED_HOSTS" > /dev/null
if [ $? -eq 0 ]
then
  echo "Result: PASSED"
else
  echo "Result: FAILED"
  exit 1
fi

echo ""
echo "---------------------------------------"
echo "- Listing tasks that will be executed -"
echo "---------------------------------------"
echo ""

ansible-playbook --list-tasks -i "$INVENTORY" "$PLAYBOOK" --limit "$TARGETED_HOSTS"

echo ""
echo "---------------------------------------"
echo "- Listing tags that are available     -"
echo "---------------------------------------"
echo ""

ansible-playbook --list-tags -i "$INVENTORY" "$PLAYBOOK" --limit "$TARGETED_HOSTS"

echo ""
echo "---------------------------------------"
echo "- Listing hosts that will be targeted -"
echo "---------------------------------------"
echo ""

ansible-playbook --list-hosts -i "$INVENTORY" "$PLAYBOOK" --limit "$TARGETED_HOSTS"

# echo ""
# echo "---------------------------------------"
# echo "- Performing dry-run of the playbook  -"
# echo "---------------------------------------"
# echo ""
#
# ansible-playbook --check -i "$INVENTORY" "$PLAYBOOK" --limit "$TARGETED_HOSTS"
# if [ $? -eq 0 ]
# then
#   echo "Result: PASSED"
# else
#   echo "Result: FAILED"
#   exit 1
# fi

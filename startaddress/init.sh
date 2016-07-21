#!/bin/bash

MYIP1="$(ip -4 address show eth0 | sed -rn 's/^[[:space:]]*inet ([[:digit:].]+)[/[:space:]].*$/\1/p')"

NODETYPE=$1
NODECOUNT=$2

LOCALIP1=$3
LOCALIP2=$4
LOCALIP3=$5

SUBNET1STARTADDRESS=$6
SUBNET2STARTADDRESS=$7
SUBNET3STARTADDRESS=$8

log()
{
	echo "$1"
	logger "$1"
}

# Initialize local variables
# Get today's date into YYYYMMDD format
NOW=$(date +"%Y%m%d")


# ---------------------------------------------------------------------------------------------


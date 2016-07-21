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

log "init.sh NOW=$NOW MYIP1=$MYIP1 NODETYPE=$NODETYPE NODECOUNT=$NODECOUNT LOCALIP1=$LOCALIP1 LOCALIP2=$LOCALIP2 LOCALIP3=$LOCALIP3 SUBNET1STARTADDRESS=$SUBNET1STARTADDRESS SUBNET2STARTADDRESS=$SUBNET2STARTADDRESS SUBNET3STARTADDRESS=$SUBNET3STARTADDRESS"

# ---------------------------------------------------------------------------------------------


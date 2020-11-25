#!/bin/bash

log()
{
    echo "$1"
    logger "$1"
}

log "$(date) Hello from custom script"

log "$(date) Block until cloud init completes..."

cloud-init status --long --wait

log "$(date) Goodbye from custom script"
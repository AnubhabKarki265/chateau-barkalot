#!/bin/bash
# Name: Anubhab Karki | Email: karki007@gannon.edu

SERVICE=$1
ACTION=$2
USER=$(whoami)
DATE=$(date)
LOGFILE="/tmp/services.logs"

log_output() {
    echo "$1"
    echo "$1" >> $LOGFILE
}

systemctl list-unit-files | grep -q "^$SERVICE.service"

if [ $? -ne 0 ]; then
    MSG="[$USER] [$DATE] The $SERVICE service is not installed"
    log_output "$MSG"

    if [ "$ACTION" == "start" ]; then
        log_output "Cannot start the $SERVICE service since it is not installed"
    elif [ "$ACTION" == "stop" ]; then
        log_output "Cannot stop the $SERVICE service since it is not installed"
    fi
    exit 1
fi

systemctl is-active --quiet $SERVICE
STATUS=$?

if [ $STATUS -eq 0 ]; then
    CURRENT_STATUS="running"
else
    CURRENT_STATUS="stopped"
fi

MSG="[$USER] [$DATE] The $SERVICE service is $CURRENT_STATUS"
log_output "$MSG"

if [ -z "$ACTION" ]; then
    exit 0
fi

if [[ "$ACTION" != "start" && "$ACTION" != "stop" ]]; then
    log_output "Invalid option \"$ACTION\" (must be \"start\" or \"stop\")"
    exit 1
fi

if [ "$ACTION" == "start" ]; then
    if [ "$CURRENT_STATUS" == "running" ]; then
        log_output "The $SERVICE service is already running!"
    else
        systemctl start $SERVICE
        log_output "Started the $SERVICE service"
    fi
fi

if [ "$ACTION" == "stop" ]; then
    if [ "$CURRENT_STATUS" == "stopped" ]; then
        log_output "The $SERVICE service is already stopped!"
    else
        systemctl stop $SERVICE
        log_output "Stopped the $SERVICE service"
    fi
fi
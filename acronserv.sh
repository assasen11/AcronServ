#!/bin/bash

services=("acronis_mms" "aakore" "acronis_mms" "acronis_schedule" "active-protection.service")

function start_service() {
    local service_name=$1
    echo "Starting $service_name..."
    sudo systemctl start "$service_name"
}

function stop_service() {
    local service_name=$1
    echo "Stopping $service_name..."
    sudo systemctl stop "$service_name"
}

function restart_service() {
    local service_name=$1
    echo "Restarting $service_name..."
    sudo systemctl restart "$service_name"
}

function check_status_service() {
    local service_name=$1
    echo "Status of $service_name:"
    sudo systemctl status "$service_name"
}

# Parse command-line options
while getopts ":srtcn:" opt; do
  case $opt in
    s) action="start" ;;
    r) action="restart" ;;
    t) action="stop" ;;
    c) action="check_status" ;;
    n) service_name="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        exit 1 ;;
  esac
done

# Perform the specified action
if [ -n "$action" ]; then
    if [ -n "$service_name" ]; then
        case $action in
            start) start_service "$service_name" ;;
            restart) restart_service "$service_name" ;;
            stop) stop_service "$service_name" ;;
            check_status) check_status_service "$service_name" ;;
        esac
    else
        # If no service name is specified, perform the action on all services
        for service in "${services[@]}"; do
            case $action in
                start) start_service "$service" ;;
                restart) restart_service "$service" ;;
                stop) stop_service "$service" ;;
                check_status) check_status_service "$service" ;;
            esac
        done
    fi
else
    echo "No action specified. Use -s, -r, -t, or -c."
fi

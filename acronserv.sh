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

function check_logs() {
    local log_path="/var/lib/Acronis/BackupAndRecovery/MMS/mms.0.log"
    echo "Last 10 lines of $log_path:"
    tail -n 10 "$log_path"
}

function show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -s               Start services"
    echo "  -r               Restart services"
    echo "  -t               Stop services"
    echo "  -c               Check status of services"
    echo "  -n <service>     Specify a particular service by name"
    echo "  -h, --help       Show this help message"
    echo "  -l               Check logs"
    exit 0
}

# Parse command-line options
while getopts ":srtcn:hl" opt; do
  case $opt in
    s) action="start" ;;
    r) action="restart" ;;
    t) action="stop" ;;
    c) action="check_status" ;;
    n) service_name="$OPTARG" ;;
    l) action="check_logs" ;;
    h) show_help ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        show_help ;;
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
            check_logs) check_logs ;;
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
        # Display logs once after processing all services
        if [ "$action" == "check_logs" ]; then
            check_logs
        fi
    fi
else
    echo "No action specified. Use -s, -r, -t, -c, -l, or -h for help."
    show_help
fi

case "$1" in
  "start")
    echo "Starting service daemon..."
    ;;
  "stop")
    echo "Stopping service daemon..."
    ;;
  "restart"|"reload")
    echo "Restarting service daemon..."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
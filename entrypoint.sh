#!/bin/bash
set -e

# make sure to run 
# >>> xhost +local:docker
# before running the container

SIMULATOR=${1:-bash}  # Default to "bash" if no argument is given

echo "==> Starting Unitree MuJoCo simulation: $SIMULATOR"

case "$SIMULATOR" in
  cpp)
    echo "Launching C++ simulator..."
    cd /root/unitree_mujoco/simulate/build
    ./unitree_mujoco &
    SIM_PID=$!
    echo "Simulator initializing..."
    sleep 2
    wmctrl -r ":ACTIVE:" -b add,maximized_vert,maximized_horz
    sleep 3
    echo "Start controller"
    ./test &
    echo "Press Ctrl+C to exit"
    wait $SIM_PID
    echo "Simulator exited. Shutting down container..."
    exit 0
    ;;

  python)
    echo "Launching Python simulator..."
    cd /root/unitree_mujoco/simulate_python
    python3 ./unitree_mujoco.py &
    SIM_PID=$!
    echo "Simulator initializing..."
    sleep 2
    wmctrl -r ":ACTIVE:" -b add,maximized_vert,maximized_horz
    sleep 3
    echo "Start controller"
    echo "Press Ctrl+C to exit"
    python3 ./test/test_unitree_sdk2.py &
    wait $SIM_PID
    echo "Simulator exited. Shutting down container..."
    exit 0
    ;;

  bash|shell)
    echo "Launching interactive shell..."
    exec bash
    ;;

  *)
    echo "Invalid simulator option: '$SIMULATOR'"
    echo "Usage: docker compose run unitree_sim2sim [cpp|python|bash]"
    exit 1
    ;;
esac


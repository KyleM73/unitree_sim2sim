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
    exec ./unitree_mujoco
    ;;

  python)
    echo "Launching Python simulator..."
    cd /root/unitree_mujoco/simulate_python
    exec python3 ./unitree_mujoco.py
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


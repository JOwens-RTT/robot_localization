#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

# setup ros2 environment
source /opt/ros/"$ROS_DISTRO"/setup.bash --
source ~/ros2_ws/install/setup.bash --

# add sourcing to .bashrc
{
    echo "source '/opt/ros/$ROS_DISTRO/setup.bash'"
    echo "source '~/ros2_ws/install/setup.bash'"
    echo "source '/usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash'"
    echo "export GZ_SIM_RESOURCE_PATH=/home/$USER/ros2_ws/src"
} >> "/home/$USER/.bashrc"

touch "/home/$USER/hello_world.txt"
echo "Hello World!" >> "/home/$USER/hello_world.txt"
exec "$@"

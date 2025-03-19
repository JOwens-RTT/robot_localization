FROM ros:humble-ros-base

ARG USERNAME=rosdev
ARG UID=1000
ARG GID=$UID

# Install some dependencies packages
RUN apt update -q \
    && apt upgrade -q -y \
    && apt install -y --no-install-recommends \
    software-properties-common \
    python3-pip \
    xauth \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Nav2
# RUN apt update -q \
#     && apt install -y --no-install-recommends \
#     ros-$ROS_DISTRO-gazebo-* \
#     ros-$ROS_DISTRO-navigation2 \
#     ros-$ROS_DISTRO-nav2-bringup \
#     ros-$ROS_DISTRO-joint-state-publisher \
#     ros-$ROS_DISTRO-joint-state-publisher-gui \
#     ros-$ROS_DISTRO-xacro \
#     ros-$ROS_DISTRO-rviz2 \
#     ros-$ROS_DISTRO-behaviortree-cpp \
#     ros-$ROS_DISTRO-robot-localization \
#     && apt clean \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create and switch to user
RUN groupadd -g $GID $USERNAME \
    && useradd -lm -u $UID -g $USERNAME -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

# Create workspace so that user own this directory
RUN mkdir -p /home/$USERNAME/ros2_ws/src
WORKDIR /home/$USERNAME/ros2_ws

# Copy configuration files
RUN echo 'source /opt/ros/'$ROS_DISTRO'/setup.bash' >> /home/$USERNAME/.bashrc \
    && echo 'source /home/'$USERNAME'/ros2_ws/install/setup.bash' >> /home/$USERNAME/.bashrc

# Add sourcing to bashrc
RUN <<EOF
#!/bin/bash
# setup ros2 environment
source /opt/ros/"$ROS_DISTRO"/setup.bash --
source ~/ros2_ws/install/setup.bash --

# add sourcing to .bashrc
if [ ! -f "/home/$USERNAME/.bashrc" ]; then
    touch "/home/$USERNAME/.bashrc"
fi
{
    echo "source '/opt/ros/$ROS_DISTRO/setup.bash'"
    echo "source '~/ros2_ws/install/setup.bash'"
    echo "source '/usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash'"
    echo "export GZ_SIM_RESOURCE_PATH=/home/$USERNAME/ros2_ws/src"
    echo "export GAZEBO_MODEL_PATH=/home/$USERNAME/ros2_ws/src/tractor_gazebo/gazebo_models:${GAZEBO_MODEL_PATH}"
} >> "/home/$USERNAME/.bashrc"
EOF

# Setup entrypoint
COPY ./ros_entrypoint.sh /
RUN sudo chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]


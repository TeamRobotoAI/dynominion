###########################################
#  Base image
###########################################
FROM ros:jazzy as base

SHELL [ "/bin/bash","-c" ]

ENV ROBOT_NAME=dynominion
ENV ROS_DISTRO=jazzy

ARG DEV_USERNAME=robotoai
ARG DEV_UID=1000
ARG DEV_GID=1000

ENV ROBOT_MODE=base
ENV DEBIAN_FRONTEND=noninteractive

# Locale
RUN apt-get update && apt-get install -y locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8

# Timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
  && apt-get update && apt-get install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/*

# Common tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils curl gnupg2 lsb-release sudo software-properties-common \
  wget git \
  && rm -rf /var/lib/apt/lists/*

# ROS tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-argcomplete python3-rosdep python3-vcstool \
  python3-colcon-common-extensions \
  && rm -rf /var/lib/apt/lists/*

# Python + virtualenv
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apt-get update && apt-get install -y \
  python3-pip virtualenv v4l-utils python3-tk magic-wormhole \
  && rm -rf /var/lib/apt/lists/*

RUN virtualenv $VIRTUAL_ENV --system-site-packages
RUN $VIRTUAL_ENV/bin/pip install catkin_pkg numpy transforms3d

# ROS packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-$ROS_DISTRO-image-transport-plugins \
  ros-$ROS_DISTRO-ros-gz \
  ros-$ROS_DISTRO-gz-tools-vendor \
  ros-$ROS_DISTRO-gz-sim-vendor \
  ros-$ROS_DISTRO-gz-ros2-control \
  ros-$ROS_DISTRO-navigation2 \
  ros-$ROS_DISTRO-nav2-bringup \
  ros-$ROS_DISTRO-nav2-route \
  ros-$ROS_DISTRO-rviz2 \
  ros-$ROS_DISTRO-robot-state-publisher \
  ros-$ROS_DISTRO-joint-state-publisher \
  ros-$ROS_DISTRO-gz-ros2-control-demos \
  ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
  ros-$ROS_DISTRO-ros2-control \
  ros-$ROS_DISTRO-ros2-controllers \
  ros-$ROS_DISTRO-laser-filters \
  ros-$ROS_DISTRO-slam-toolbox \
  ros-$ROS_DISTRO-tf2* \
  ros-$ROS_DISTRO-tf-transformations \
  ros-$ROS_DISTRO-v4l2-camera \
  && rm -rf /var/lib/apt/lists/*

# Create user
RUN if [ "$DEV_UID" -ne 0 ] && id -u "$DEV_UID" >/dev/null 2>&1; then \
  userdel -r $(id -un "$DEV_UID"); \
  fi

RUN groupadd --gid $DEV_GID $DEV_USERNAME \
  && useradd --uid $DEV_UID --gid $DEV_GID -m $DEV_USERNAME \
  && echo $DEV_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$DEV_USERNAME \
  && chmod 0440 /etc/sudoers.d/$DEV_USERNAME

RUN chown -R $DEV_USERNAME:$DEV_USERNAME $VIRTUAL_ENV

USER $DEV_USERNAME
WORKDIR /home/$DEV_USERNAME

###########################################
# Dynominion (local source)
###########################################
FROM base AS dynominion

ENV ROBOT_MODE=dynominion
ENV DEV_WORKDIR=/home/$DEV_USERNAME/$ROBOT_NAME

# Create workspace
RUN mkdir -p $DEV_WORKDIR/src $DEV_WORKDIR/maps

# Copy local code
COPY . $DEV_WORKDIR/src

# Fix ownership
USER root
RUN chown -R $DEV_USERNAME:$DEV_USERNAME $DEV_WORKDIR

# Setup environment
RUN cat <<EOF > /home/$DEV_USERNAME/sources.bashrc
source /opt/ros/$ROS_DISTRO/setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

export ROS_DOMAIN_ID=5
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

source $DEV_WORKDIR/install/setup.bash
EOF

RUN cat /home/$DEV_USERNAME/sources.bashrc >> /home/$DEV_USERNAME/.bashrc

RUN touch /home/$DEV_USERNAME/.Xauthority

USER $DEV_USERNAME
WORKDIR $DEV_WORKDIR

# Build workspace
RUN source /opt/ros/$ROS_DISTRO/setup.bash \
  && rosdep update \
  && rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y \
  && colcon build

# Dev tools
RUN sudo apt-get update && sudo apt-get install -y \
  iputils-ping nano tmux \
  && sudo rm -rf /var/lib/apt/lists/*

CMD ["bash"]
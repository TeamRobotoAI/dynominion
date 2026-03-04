###########################################
#  Base image
###########################################
FROM ros:jazzy as base

SHELL [ "/bin/bash","-c" ]

#robot
ENV ROBOT_NAME=dynominion

#ros
ENV ROS_DISTRO=jazzy

ARG DEV_USERNAME=robotoai
ARG DEV_UID=1000
ARG DEV_GID=1000

ENV ROBOT_MODE=base

ENV DEBIAN_FRONTEND=noninteractive

# Install language
RUN apt-get update && apt-get install -y \
  locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/*

# Install common programs
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  curl \
  gnupg2 \
  lsb-release \
  sudo \
  software-properties-common \
  wget \
  git \
  && rm -rf /var/lib/apt/lists/*

# Install ROS2
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-argcomplete \
  python3-rosdep \
  python3-vcstool \
  python3-colcon-common-extensions \
  && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=

## virtualenv
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ENV DEBIAN_FRONTEND=noninteractive

# Install apt packages
RUN apt-get update && apt-get install -y \
  python3-pip \
  virtualenv \
  v4l-utils \
  python3-tk \
  magic-wormhole \
  && rm -rf /var/lib/apt/lists/*


# Install apt-ros packages
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

#Create a virtual environment and Install pip packages
RUN virtualenv $VIRTUAL_ENV --system-site-packages
RUN $VIRTUAL_ENV/bin/pip install \
  catkin_pkg \
  numpy \
  transforms3d

ENV DEBIAN_FRONTEND=

# Check if any group with the same UID already exists
RUN if [ "$DEV_UID" -ne 0 ] && id -u "$DEV_UID" >/dev/null 2>&1; then \
  userdel -r $(id -un "$DEV_UID"); \
  fi

# Create the user
RUN groupadd --gid $DEV_GID $DEV_USERNAME \
  && useradd --uid $DEV_UID --gid $DEV_GID -m $DEV_USERNAME \
  && echo $DEV_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$DEV_USERNAME \
  && chmod 0440 /etc/sudoers.d/$DEV_USERNAME

# Grant access to the virtual environment
RUN chown -R $DEV_USERNAME:$DEV_USERNAME $VIRTUAL_ENV

USER $DEV_USERNAME
WORKDIR /home/$DEV_USERNAME

FROM base AS dynominion

#  Develop settings
ENV ROBOT_MODE=dynominion
ENV DEV_WORKDIR=/home/$DEV_USERNAME/$ROBOT_NAME

ENV DEBIAN_FRONTEND=noninteractive

# Generate .repo file
RUN cat <<EOF > dynoatman.repos
repositories:
    src:
        type: git
        url: https://github.com/TeamRobotoAI/dynominion.git
        version: main
EOF

# Clone repo
RUN mkdir -p $DEV_WORKDIR/src $DEV_WORKDIR/maps
RUN vcs import $DEV_WORKDIR/ < dynoatman.repos

# Set the ownership of the repo dir 
RUN chown -R $DEV_USERNAME:$DEV_USERNAME $DEV_WORKDIR

# Copy source file to user and add it to bashrc
RUN cat <<EOF > sources.bashrc
#ros
source "/opt/ros/$ROS_DISTRO/setup.bash"

#colcon autocomplete
source "/usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash"

#set ROS DOMAIN ID
export ROS_DOMAIN_ID=5
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

#workspace
source "$DEV_WORKDIR/install/setup.bash"

EOF

# Copy to bashrc
RUN cat sources.bashrc >> /home/$DEV_USERNAME/.bashrc

# Login to user
USER $DEV_USERNAME

# Setting the repo dir as workdir
WORKDIR $DEV_WORKDIR

# Build ther ros2 pkg's
RUN source /opt/ros/$ROS_DISTRO/setup.bash \
  && sudo apt update \
  && rosdep update \
  && rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y \
  && colcon build \
  && sudo rm -rf /var/lib/apt/lists/*

# Install packages required for dev
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  iputils-ping \
  nano \
  tmux \
  && sudo rm -rf /var/lib/apt/lists/*

RUN echo "trigger"

ENV DEBIAN_FRONTEND=
#dynominion_slam

###Overview

The dynominion_slam package enables SLAM Toolbox–based mapping for the Dynominion robot. It provides both online and offline mapping capabilities to support flexible and efficient map generation.

This package integrates SLAM Toolbox with the Dynominion robot to perform simultaneous localization and mapping. 

It includes multiple launch configurations for different mapping modes and uses parameter files stored in the **config/** folder for customization.

The launch folder includes three main launch files:
	- online_async_launch.py – Performs live mapping asynchronously. The map is updated after loop closures or periodic optimizations.
    - online_sync_launch.py – Performs live mapping synchronously, updating the map with each incoming sensor measurement.
    - offline_launch.py – Used for offline mapping with previously recorded data stored as ROS bags.

###Package Structure

dynominion_slam
#dynominion_slam

###Overview

The dynominion_slam package enables SLAM Toolbox–based mapping for the Dynominion robot. It provides both online and offline mapping capabilities to support flexible and efficient map generation.

This package integrates SLAM Toolbox with the Dynominion robot to perform simultaneous localization and mapping. 

It includes multiple launch configurations for different mapping modes and uses parameter files stored in the **config/** folder for customization.

The launch folder includes three main launch files:
	- online_async_launch.py – Performs live mapping asynchronously. The map is updated after loop closures or periodic optimizations.
    - online_sync_launch.py – Performs live mapping synchronously, updating the map with each incoming sensor measurement.
    - offline_launch.py – Used for offline mapping with previously recorded data stored as ROS bags.

###Package Structure

dynominion_slam     
├── CMakeLists.txt  
├── config  
│   ├── laser_filter.yaml   
│   ├── mapper_params_offline.yaml  
│   ├── mapper_params_online_async.yaml     
│   └── mapper_params_online_sync.yaml  
├── include     
│   └── dynominion_slam     
├── launch      
│   ├── offline_launch.py       
│   ├── online_async_launch.py      
│   └── online_sync_launch.py   
├── package.xml     
├── README.md   
└──rviz     
   └── mapping.rviz 


###Package Requirements 

    - slam_toolbox
    - laser_filters

Additional requirement:
    - rosbag2 (for offline mapping)

###Launch

   `ros2 launch dynominion_slam online_async_launch.py` 
   `ros2 launch dynominion_slam online_sync_launch.py`  
   `ros2 launch dynominion_slam offline_launch.py`

###Package Requirements 

    - slam_toolbox
    - laser_filters

Additional requirement:
    - rosbag2 (for offline mapping)

###Launch

   `ros2 launch dynominion_slam online_async_launch.py` 
   `ros2 launch dynominion_slam online_sync_launch.py`  
   `ros2 launch dynominion_slam offline_launch.py`
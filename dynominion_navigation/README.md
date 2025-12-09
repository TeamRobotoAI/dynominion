#   dynominion_navigation

### Overview

This package provides the main navigation stack for the Dynominion robot. It integrates ROS 2 Navigation (Nav2) components, enabling autonomous movement, path planning.

This package launches the Nav2 stack for Dynominion using the dynominion_nav_bringup.launch.py file. By default, it creates a ROS 2 container and loads all required navigation plugins within it.

The navigation parameters and configuration files are stored in the **config/** folder.

All parameters used in the configuration are based on the default Nav2 examples, except for the customized footprint and collision settings, which are tailored for the Dynominion robot’s geometry.

### Package Structure

dynominion_navigation       
├── CMakeLists.txt      
├── config      
│   └── nav_param.yaml      
├── launch      
│   ├── dynominion_nav_bringup.launch.py        
│   └── navigation_launch.py    
├── package.xml     
├── README.md       
└── rviz        
    └── nav2_view.rviz  

### Package Requirements

    - nav2_bringup
    - Navigation2 packages
    - tf2_ros
    - geometry_msgs, sensor_msgs

### Launch
    
    ```bash
    ros2 launch dynominion_navigation dynominion_nav_bringup.launch.py
    ```
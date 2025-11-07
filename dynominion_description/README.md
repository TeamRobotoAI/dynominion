# **dynominion_description**

### Overview

The Dynominion package encapsulates the geometric and visual aspects of the robot—expressed through a URDF (Unified Robot Description Format) model—enabling accurate simulation, visualization, and robot description for use with ROS 2 ecosystems.
---
### Package structure

dynominion_description
|   CMakeLists.txt
|   package.xml
|   README.md
|   
+---meshes
|       base_link.STL
|       imu_l4.STL
|       left_wheel_l2.STL
|       lidar_l3.STL
|       right_wheel_l1.STL
|       
\---urdf
        dynominion.materials.xacro
        dynominion_description.urdf.xacro
---


### System Requirements

         - urdf, 
         - xacro




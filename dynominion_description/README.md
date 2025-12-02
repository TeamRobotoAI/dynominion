#dynominion_description

###Overview

The Dynominion package encapsulates the geometric and visual aspects of the robot—expressed through a URDF (Unified Robot Description Format) model—enabling accurate simulation, visualization, and robot description for use with ROS 2 ecosystems.

###Package structure

dynominion_description      
├── CMakeLists.txt      
├── meshes      
│   ├── base_link.STL       
│   ├── castor_1.STL        
│   ├── castor_2.STL        
│   ├── castor_3.STL        
│   ├── castor_4.STL        
│   ├── imu_l4.STL      
│   ├── left_wheel_l2.STL       
│   ├── lidar_l3.STL        
│   └── right_wheel_l1.STL      
├── package.xml     
├── README.md       
└── urdf        
    ├── dynominion_description.urdf.xacro       
    └── dynominion.materials.xacro      

###System Requirements

         - urdf, 
         - xacro

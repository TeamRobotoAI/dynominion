#   teleop_robot

## Overview

This package is used to publish messages in the topic **/cmd_vel** of type **geometry_msgs/msg/TwistStamped**, which act as control commands for the Dynominion robot.

The node instructions are provided within the node itself and can be viewed when the node is executed.

It serves as a teleoperation control module, allowing the user to move the robot manually

The node sends stepwise velocity commands that change in small units, producing stable and controllable robot movement.

## Package Structure
```
teleop_robot    
├── README.md   
├── resource    
│   └── teleop_robot    
├── setup.cfg   
├── setup.py    
├── teleop_robot    
│   ├── __init__.py     
│   └── teleop_key.py   
└── test    
    ├── test_copyright.py   
    ├── test_flake8.py  
    └── test_pep257.py  
```
## Requirements

| Package | Purpose |
|---------|---------|
| `rclpy` | Python client library for ROS 2 nodes and communication |
| `geometry_msgs` | Provides standard geometric message types |

## Node
    
```bash
ros2 run teleop_robot teleop_key
```

![Teleop Command](doc/teleop_cmd.png)

---

## Teleop Demo

![Teleop Demo](doc/teleop.gif)
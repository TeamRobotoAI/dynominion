# DYNOMINION X

### Functionalities

**Dynominion X** is the fully functionable Autonomous Mobile Robot for Education Purpose. It can demonstrate the purpose of fully functioned AMRs as well as every sub systems for better understanding to the researchers and educators. 

1. Teleoperation - Dynominion X can be moved with the control commands for the user in this process
2. Mapping - Dynominion X can record its environment in the Occupancy Grid Map with the help of user in this process.
3. Path Planning - With the input of environment , its current location and its destination, Dynominion X can plan its own path based on Planner that user chose.
4. Motion Control - With the plan from the Planner , Dynominion X can make its own drive commands based on the user selected controller. 
Note: Dynominion X uses Differential Drive System. So user must choose the controller which works dor differential drive system.
5. Collision Safety - Dynominion X has collision safety pre build in it while navigating on its own. User may also include it while teleoperating but its their own choice. The Safety polygons must be choosen by the User based on their environment and requirement.

### Launch

Dynominion X has multiple launch files for its operation. The following passages are in the form of description of launch file and launch command.

1. To active the entire system i.e. activate all the sensor and establish all the **tf** s  , the command is

```bash
ros2 launch mini_amr_bringup mini_amr_bringup.launch.py
```

2. To teleoperate the Dynominion X with the system keyboard ,

```bash
ros2 run teleop_robot teleop_key
```

3. To map the environment, the user needs to teleoperate the robot along with this command

```bash
ros2 launch mini_amr_nav_bringup online_async_map.launch.py
```

4. To start the autonomous navigation process,

```bash
ros2 launch mini_amr_nav_bringup mini_amr_nav_bringup.launch.py
```


### Services

Dynominion X has serveral service for the its functionalities.

#### Save Map

```bash
ros2 service call /slam_toolbox/save_map slam_toolbox/srv/SaveMap "{name: {data: map_name}}"
```

map_name is user choice. If the map successfully saved , the result of the response would be 0. The map is saved in the map directory.

#### Load Map

```bash
ros2 service call /map_server/load_map nav2_msgs/srv/LoadMap "{map_url: map_path}"
```

After launching the navigation script , the user must load the appropriate map of that environment before using.

### Topics

Dynominion X has many topics while in autonomous navigation mode. In this sub module, only few important topics are discussed.

1. /scan - laserscan topic from the 2D lidar.
2. /scan_filtered - filtered laserscan topic for mapping.
3. /imu/data - Imu Topic from the IMU.
4. /wheelodom - Odometry topic from the Wheel Encoders.
5. /battery_voltage - Voltage in V of the main battery.
6. /odometry/filtered - Odemetry topic from Sensor Fusion.
7. /cmd_vel - Control Twist command topic for the motors.
8. /cmd_pose - Control Pose command topic for the motors.

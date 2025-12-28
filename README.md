# Simulink Orbital Debris Avoidance RL

This project implements an autonomous satellite navigation and 3D orbital debris avoidance system using **Reinforcement Learning (RL)** in **MATLAB/Simulink**. The agent is trained to maintain a stable orbit while dynamically avoiding multiple high-speed debris objects in a 3D space.

## 🚀 Project Overview

The core of the project is a Simulink-based environment that simulates orbital mechanics and debris interactions. The RL agent learns to apply thrust to avoid collisions while staying within the target orbital parameters.

### Key Features
- **3D Orbital Mechanics:** Full X, Y, and Z axis movement simulation.
- **Curriculum Learning:** Training is divided into three phases (Easy, Medium, Hard) with increasing debris speed and proximity to improve convergence.
- **Multi-Object Avoidance:** The agent tracks and avoids 3 dynamic debris objects simultaneously.
- **Simulink Integration:** Uses `rlSimulinkEnv` for seamless integration between the RL Toolbox and Simulink models.
- **Real-time Visualization:** Integrated with VR Viewer/V-Realm for 3D monitoring during training and inference.

## 📂 Project Structure

- `RL_Satellite_Model.slx`: The main Simulink model containing the satellite dynamics and RL agent block.
- `train_3d.m`: Main script to configure and start the training process.
- `agent_installation.m`: Script to initialize environment parameters, observation spaces, and debris characteristics.
- `resetFcn.m`: Custom reset function for the RL environment, implementing the curriculum learning logic.
- `DebrisAgent_Final.mat`: Pre-trained RL agent ready for testing.
- `space_world.wrl`: VRML world file for 3D visualization.

## 🛠️ Requirements

- MATLAB (R2021b or later recommended)
- Simulink
- Reinforcement Learning Toolbox
- Aerospace Blockset (optional, for advanced dynamics)
- Simulink 3D Animation (for visualization)

## 🚦 How to Run

1. **Setup:** Open MATLAB and navigate to the project folder.
2. **Initialize:** Run `agent_installation.m` to load parameters into the workspace.
3. **Train:** Run `train_3d.m` to start the training process. You can monitor progress via the Training Manager.
4. **Test:** Open `RL_Satellite_Model.slx` and run the simulation using the pre-trained `DebrisAgent_Final.mat`.

## 🧠 Reinforcement Learning Details

- **Algorithm:** (e.g., DDPG / PPO / TD3 - *Note: Check your agent block in Simulink*)
- **Observation Space:** 15x1 vector including satellite position, velocity, and relative positions/velocities of debris.
- **Action Space:** Continuous thrust values for X, Y, and Z axes.
- **Reward Function:** Penalizes collisions and excessive fuel consumption; rewards maintaining target orbit and distance from debris.

---
*Developed as part of an Autonomous Space Systems research project.*

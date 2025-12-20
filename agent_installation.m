

%% 3 Boyutlu (X, Y, Z) hareket

%% PARAMETRELER
Ts = 0.1;
mu = 3.986e14;
m_sat = 1000;
max_thrust = 10000;
r_target = 7e6;

% Uydu baslangic 
x0 = 7e6;
y0 = 0;
z0 = 0; 
vx0 = 0;
vy0 = 7546;
vz0 = 0;

%% DEBRIS 1 (3D)
debris1_x0 = 7.3e6;
debris1_y0 = 0.3e6;
debris1_z0 = 0.1e6;  
debris1_speed = 6000;
debris1_angle = atan2(y0 - debris1_y0, x0 - debris1_x0);
debris1_vx = debris1_speed * cos(debris1_angle);
debris1_vy = debris1_speed * sin(debris1_angle);
debris1_vz = 0;

%% DEBRIS 2 (3D)
debris2_x0 = 7.5e6;
debris2_y0 = -0.4e6;
debris2_z0 = -0.15e6;  
debris2_speed = 5000;
debris2_angle = atan2(y0 - debris2_y0, x0 - debris2_x0);
debris2_vx = debris2_speed * cos(debris2_angle);
debris2_vy = debris2_speed * sin(debris2_angle);
debris2_vz = 0;

%% DEBRIS 3 (3D)
debris3_x0 = 7.8e6;
debris3_y0 = 0.1e6;
debris3_z0 = 0.05e6;  
debris3_speed = 7000;
debris3_angle = atan2(y0 - debris3_y0, x0 - debris3_x0);
debris3_vx = debris3_speed * cos(debris3_angle);
debris3_vy = debris3_speed * sin(debris3_angle);
debris3_vz = 0;

%% OBSERVATION SPACE [15x1]
% [sat: x, y, z, vx, vy, vz (6)] + [deb1: x, y, z (3)] + [deb2: x, y, z (3)] + [deb3: x, y, z (3)]
obsInfo = rlNumericSpec([15 1], ...
    'LowerLimit', -2*ones(15,1), ...
    'UpperLimit', 2*ones(15,1));
obsInfo.Name = 'Observation';
obsInfo.Description = '3D Satellite state + 3 Debris positions';

%% ACTION SPACE [3x1] 
% [thrust_x, thrust_y, thrust_z] - dogrudan X, Y, Z yonunde kuvvet
actInfo = rlNumericSpec([3 1], ...
    'LowerLimit', [-1; -1; -1], ...
    'UpperLimit', [1; 1; 1]);
actInfo.Name = 'Action';
actInfo.Description = 'Thrust in X, Y, Z directions';

%% PPO AJAN - STABIL EGITIM AYARLARI
agentOpts = rlPPOAgentOptions(...
    'ExperienceHorizon', 1024, ...      % Daha uzun pencere
    'ClipFactor', 0.1, ...
    'EntropyLossWeight', 0.05, ...      
    'MiniBatchSize', 128, ...
    'NumEpoch', 4, ...
    'SampleTime', Ts, ...
    'DiscountFactor', 0.99, ...
    'AdvantageEstimateMethod', 'gae', ...
    'GAEFactor', 0.95);

% Varsayilan aglar
initOpts = rlAgentInitializationOptions(...
    'NumHiddenUnit', 128, ...
    'UseRNN', false);

agentObj = rlPPOAgent(obsInfo, actInfo, initOpts, agentOpts);


disp(['   Observation: ', num2str(obsInfo.Dimension(1)), ' boyutlu']);
disp('     - Satellite: x, y, z, vx, vy, vz (6)');
disp('     - Debris1: x, y, z (3)');
disp('     - Debris2: x, y, z (3)');
disp('     - Debris3: x, y, z (3)');
disp(['   Action: ', num2str(actInfo.Dimension(1)), ' boyutlu']);
disp('     - Thrust X, Y, Z');
disp('===========================================');

function in = resetFcn(in)
%% RESET FONKSIYONU

    mdl = 'RL_Satellite_Model';
    mu = 3.986e14;
    r_target = 7e6;
    
    %% CURRICULUM LEARNING 
    persistent episode_count;
    if isempty(episode_count)
        episode_count = 0;
    end
    episode_count = episode_count + 1;
    
    % Zorluk fazlari - DAHA UZAK MESAFELER
    if episode_count <= 200
        % FAZ 1: KOLAY
        min_dist = 3.5e5;   % 350 km
        max_dist = 5e5;     % 500 km
        min_speed = 1500;
        max_speed = 2500;
        max_z = 5e4;        % 50 km
    elseif episode_count <= 500
        % FAZ 2: ORTA
        min_dist = 3e5;     % 300 km
        max_dist = 4.5e5;   % 450 km
        min_speed = 2000;
        max_speed = 3000;
        max_z = 4e4;        % 40 km
    else
        % FAZ 3: ZOR
        min_dist = 2.5e5;   % 250 km
        max_dist = 4e5;     % 400 km
        min_speed = 2500;
        max_speed = 3500;
        max_z = 3e4;        % 30 km
    end
    
    %% UYDU - 3D RASTGELE BASLANGIÇ
    sat_angle = rand * 2 * pi;
    x0 = r_target * cos(sat_angle);
    y0 = r_target * sin(sat_angle);
    z0 = (rand - 0.5) * 2e4;  % ±10 km baslangic Z (kucuk)
    vx0 = -sqrt(mu/r_target) * sin(sat_angle);
    vy0 = sqrt(mu/r_target) * cos(sat_angle);
    vz0 = 0;
    
    %% DEBRIS 1 - YUKARIDAN GELEN
    debris1_dist = min_dist + (max_dist - min_dist) * rand;
    debris1_dir = rand * 2 * pi;  % XY duzleminde rastgele aci
    debris1_x0 = x0 + debris1_dist * cos(debris1_dir);
    debris1_y0 = y0 + debris1_dist * sin(debris1_dir);
    debris1_z0 = z0 + max_z * (0.5 + rand*0.5);  % HERZAMAN YUKARIDA (+Z)
    debris1_speed = min_speed + (max_speed - min_speed) * rand;
    dir1 = atan2(y0 - debris1_y0, x0 - debris1_x0) + (rand-0.5)*0.3;
    debris1_vx = 0.5*vx0 + debris1_speed * cos(dir1);
    debris1_vy = 0.5*vy0 + debris1_speed * sin(dir1);
    % Asagi dogru hiz (uyduya dogru)
    debris1_vz = -(500 + rand*1000);  % Negatif = asagi
    
    %% DEBRIS 2 - ASAGIDAN GELEN
    debris2_dist = min_dist + (max_dist - min_dist) * rand;
    debris2_dir = rand * 2 * pi;
    debris2_x0 = x0 + debris2_dist * cos(debris2_dir);
    debris2_y0 = y0 + debris2_dist * sin(debris2_dir);
    debris2_z0 = z0 - max_z * (0.5 + rand*0.5);  % HERZAMAN ASAGIDA (-Z)
    debris2_speed = min_speed + (max_speed - min_speed) * rand;
    dir2 = atan2(y0 - debris2_y0, x0 - debris2_x0) + (rand-0.5)*0.3;
    debris2_vx = 0.5*vx0 + debris2_speed * cos(dir2);
    debris2_vy = 0.5*vy0 + debris2_speed * sin(dir2);
    % Yukari dogru hiz (uyduya dogru)
    debris2_vz = +(500 + rand*1000);  % Pozitif = yukari
    
    %% DEBRIS 3 - YANDAN GELEN (XY duzleminde)
    debris3_dist = min_dist * 0.7 + (max_dist - min_dist) * rand * 0.5;  % Daha yakin
    debris3_dir = rand * 2 * pi;
    debris3_x0 = x0 + debris3_dist * cos(debris3_dir);
    debris3_y0 = y0 + debris3_dist * sin(debris3_dir);
    debris3_z0 = z0 + (rand - 0.5) * max_z * 0.3;  % Z'de az sapma
    debris3_speed = min_speed * 1.5 + (max_speed - min_speed) * rand;  % Daha hizli
    dir3 = atan2(y0 - debris3_y0, x0 - debris3_x0);  % Direkt uyduya
    debris3_vx = 0.5*vx0 + debris3_speed * cos(dir3);
    debris3_vy = 0.5*vy0 + debris3_speed * sin(dir3);
    debris3_vz = (rand - 0.5) * 300;  % Az Z hareketi
    
    %% UYDU DEGISKENLERI
    in = setVariable(in, 'x0', x0);
    in = setVariable(in, 'y0', y0);
    in = setVariable(in, 'z0', z0);
    in = setVariable(in, 'vx0', vx0);
    in = setVariable(in, 'vy0', vy0);
    in = setVariable(in, 'vz0', vz0);
    
    %% DEBRIS 1 - degiskenler
    in = setVariable(in, 'debris1_x0', debris1_x0);
    in = setVariable(in, 'debris1_y0', debris1_y0);
    in = setVariable(in, 'debris1_z0', debris1_z0);
    in = setVariable(in, 'debris1_vx', debris1_vx);
    in = setVariable(in, 'debris1_vy', debris1_vy);
    in = setVariable(in, 'debris1_vz', debris1_vz);
    
    %% DEBRIS 2 - degiskenler
    in = setVariable(in, 'debris2_x0', debris2_x0);
    in = setVariable(in, 'debris2_y0', debris2_y0);
    in = setVariable(in, 'debris2_z0', debris2_z0);
    in = setVariable(in, 'debris2_vx', debris2_vx);
    in = setVariable(in, 'debris2_vy', debris2_vy);
    in = setVariable(in, 'debris2_vz', debris2_vz);
    
    %% DEBRIS 3 - degiskenler
    in = setVariable(in, 'debris3_x0', debris3_x0);
    in = setVariable(in, 'debris3_y0', debris3_y0);
    in = setVariable(in, 'debris3_z0', debris3_z0);
    in = setVariable(in, 'debris3_vx', debris3_vx);
    in = setVariable(in, 'debris3_vy', debris3_vy);
    in = setVariable(in, 'debris3_vz', debris3_vz);
    
    %% INTEGRATOR IC GUNCELLE 
    % Bu, SimulationInput uzerinden integrator IC'lerini gunceller
    try
        % Debris1 pozisyon integrator IC
        in = setBlockParameter(in, [mdl '/Debris1_Dynamics/Integrator'], 'InitialCondition', num2str(debris1_x0));
        in = setBlockParameter(in, [mdl '/Debris1_Dynamics/Integrator1'], 'InitialCondition', num2str(debris1_y0));
        in = setBlockParameter(in, [mdl '/Debris1_Dynamics/Integrator2'], 'InitialCondition', num2str(debris1_z0));
        
        % Debris2 pozisyon integrator IC
        in = setBlockParameter(in, [mdl '/Debris2_Dynamics/Integrator'], 'InitialCondition', num2str(debris2_x0));
        in = setBlockParameter(in, [mdl '/Debris2_Dynamics/Integrator1'], 'InitialCondition', num2str(debris2_y0));
        in = setBlockParameter(in, [mdl '/Debris2_Dynamics/Integrator2'], 'InitialCondition', num2str(debris2_z0));
        
        % Debris3 pozisyon integrator IC
        in = setBlockParameter(in, [mdl '/Debris3_Dynamics/Integrator'], 'InitialCondition', num2str(debris3_x0));
        in = setBlockParameter(in, [mdl '/Debris3_Dynamics/Integrator1'], 'InitialCondition', num2str(debris3_y0));
        in = setBlockParameter(in, [mdl '/Debris3_Dynamics/Integrator2'], 'InitialCondition', num2str(debris3_z0));
    catch ME
 
        fprintf('   [UYARI] Integrator IC ayarlanamadi: %s\n', ME.message);
    end
    
    % Base workspace - TUM degiskenler
    assignin('base', 'x0', x0);
    assignin('base', 'y0', y0);
    assignin('base', 'z0', z0);
    assignin('base', 'vx0', vx0);
    assignin('base', 'vy0', vy0);
    assignin('base', 'vz0', vz0);
    
    assignin('base', 'debris1_x0', debris1_x0);
    assignin('base', 'debris1_y0', debris1_y0);
    assignin('base', 'debris1_z0', debris1_z0);
    assignin('base', 'debris1_vx', debris1_vx);
    assignin('base', 'debris1_vy', debris1_vy);
    assignin('base', 'debris1_vz', debris1_vz);
    
    assignin('base', 'debris2_x0', debris2_x0);
    assignin('base', 'debris2_y0', debris2_y0);
    assignin('base', 'debris2_z0', debris2_z0);
    assignin('base', 'debris2_vx', debris2_vx);
    assignin('base', 'debris2_vy', debris2_vy);
    assignin('base', 'debris2_vz', debris2_vz);
    
    assignin('base', 'debris3_x0', debris3_x0);
    assignin('base', 'debris3_y0', debris3_y0);
    assignin('base', 'debris3_z0', debris3_z0);
    assignin('base', 'debris3_vx', debris3_vx);
    assignin('base', 'debris3_vy', debris3_vy);
    assignin('base', 'debris3_vz', debris3_vz);
    
    %% INTEGRATOR IC - DEVRE DISI (calisma zamaninda sorun cikariyor)
    % try
    %     set_param calls removed
    % catch
    % end
    
    fprintf('   [Reset 3D] Debris: (%.0f km, z=%.0f), (%.0f km, z=%.0f), (%.0f km, z=%.0f)\n', ...
        debris1_dist/1000, debris1_z0/1000, ...
        debris2_dist/1000, debris2_z0/1000, ...
        debris3_dist/1000, debris3_z0/1000);
end

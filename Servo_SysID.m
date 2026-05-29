% Load CSV 
data = readmatrix('Servoos.csv'); 

% Extract raw signals
time_ms = data(:,1); 
u = data(:,2);   % PWM input
y = data(:,3);   % Angle output (degrees)

% Convert to seconds
time = time_ms / 1000;
Ts = mean(diff(time));  % Sampling time

% Prepend zeros (improve transient capture)
n_prepend = 300;  % Can try 500 if needed
u = [zeros(n_prepend,1); u];
y = [zeros(n_prepend,1); y];
t = (0:length(u)-1)' * Ts;

% Filter angle output to remove noise
y_filtered = lowpass(y, 5, 1/Ts);  % 5 Hz cutoff

% Create IDDATA object
data_id = iddata(y_filtered, u, Ts);

% Try lower model order first
sys_tf = tfest(data_id, 2, 1);
fprintf('Model Fit Accuracy: %.2f%%\n', sys_tf.Report.Fit.FitPercent);
% Discretize it
sys_d = c2d(sys_tf, Ts, 'zoh');

% Tune PID
C = pidtune(sys_d, 'PID');

% View closed-loop response
T_closed = feedback(C * sys_d, 1);
step(T_closed);
title('Closed-Loop Step Response with Tuned PID');

% Display results
disp(sys_tf);
disp(C);

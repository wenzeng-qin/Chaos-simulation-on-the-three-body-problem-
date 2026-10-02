% Three-body problem in 3D: sensitivity to initial conditions
% Two runs that differ by 1e-8 in one coordinate of one body, overlaid
% on the same plot so the chaotic divergence is visible.
% Used Claude sonnet here
clear; close all; clc;

%% Setup
G = 1;
m = [3 4 5];                          % masses

% initial positions (each column is one body: [x; y; z])
r0 = [ 1    -2    1;
       3    -1   -1;
       0.2  -0.1  0.15];

s0      = [r0(:); zeros(9,1)];        % state = [positions; velocities], released from rest
s0_pert = s0;
s0_pert(1) = s0_pert(1) + 1e-8;       % nudge x of body 1

%% Solve both runs
Tmax  = 150;                          % extended so the divergence has time to show
tspan = linspace(0, Tmax, 3000);      % shared time grid, needed to animate both runs together
opts  = odeset('RelTol', 1e-11, 'AbsTol', 1e-13);
f = @(t,s) nbody(s, m, G);

[~, S1] = ode45(f, tspan, s0,      opts);   % unperturbed
[~, S2] = ode45(f, tspan, s0_pert, opts);   % perturbed

%% Plot: both runs overlaid, same axes
figure; hold on; grid on; axis equal; view(35,25);
for i = 1:3
    c = 3*i - 2 : 3*i;
    plot3(S1(:,c(1)), S1(:,c(2)), S1(:,c(3)), 'b', 'LineWidth', 1.2);
    plot3(S2(:,c(1)), S2(:,c(2)), S2(:,c(3)), 'r', 'LineWidth', 1.2);
end
xlabel('x'); ylabel('y'); zlabel('z');
title('Blue = unperturbed,  Red = perturbed by 1e-8');

% final separation between the two runs (summed over all 3 bodies)
sep = norm(S1(end,1:9) - S2(end,1:9));
fprintf('Separation between the two runs at t = %d: %.4g\n', Tmax, sep);

%% Animation: blue = unperturbed, red = perturbed
lims = 1.1*max(abs([S1(:,1:9); S2(:,1:9)]), [], 'all');

figure; hold on; grid on; axis equal; view(35,25);
xlim([-lims lims]); ylim([-lims lims]); zlim([-lims lims]);
xlabel('x'); ylabel('y'); zlabel('z');
title('Blue = unperturbed,  Red = perturbed by 1e-8');

h1 = gobjects(3,1); h2 = gobjects(3,1);
for i = 1:3
    h1(i) = plot3(0,0,0,'o','MarkerFaceColor','b','MarkerEdgeColor','k');
    h2(i) = plot3(0,0,0,'o','MarkerFaceColor','r','MarkerEdgeColor','k');
end

for k = 1:4:numel(tspan)
    for i = 1:3
        c = 3*i - 2 : 3*i;
        set(h1(i), 'XData', S1(k,c(1)), 'YData', S1(k,c(2)), 'ZData', S1(k,c(3)));
        set(h2(i), 'XData', S2(k,c(1)), 'YData', S2(k,c(2)), 'ZData', S2(k,c(3)));
    end
    drawnow;
end

%% Equations of motion
function dsdt = nbody(s, m, G)
    pos = reshape(s(1:9),  3, 3);     % each column = one body
    vel = reshape(s(10:18), 3, 3);
    acc = zeros(3,3);

    for i = 1:3
        for j = 1:3
            if j ~= i
                d = pos(:,j) - pos(:,i);
                acc(:,i) = acc(:,i) + G*m(j)*d/norm(d)^3;
            end
        end
    end

    dsdt = [vel(:); acc(:)];
end

clc; clear; close all;

%% ===== Merry Cristmax 2025 by Parmesh Kumar =====

fig = figure( ...
    'Color','w', ...
    'Renderer','opengl', ...
    'Units','pixels', ...
    'Position',[100 100 1920 1008]);
set(fig,'Renderer','opengl');
set(fig,'GraphicsSmoothing','on');

axis off equal
hold on
view([-25 20])
camproj perspective
camva(8)
xlim([-7 7]); ylim([-7 7]); zlim([-2 16]);

%% ===== CAPTION LETTER SETUP =====
line1 = 'Merry Christmas 2025';
line2 = 'by Parmesh Kumar';

nChar1 = length(line1);
nChar2 = length(line2);

captionZ1 = 16.2;      % first line height
captionZ2 = 14.2;      % second line slightly below

cap1 = gobjects(nChar1,1);
cap2 = gobjects(nChar2,1);

xStep1 = 0.55;
xStep2 = 0.45;

xStart1 = -xStep1 * (nChar1-1)/2;
xStart2 = -xStep2 * (nChar2-1)/2;

for i = 1:nChar1
    cap1(i) = text(xStart1 + (i-1)*xStep1, 0, captionZ1, line1(i), ...
        'Color',[0 0 0], ...
        'FontSize',22, ...
        'FontWeight','bold', ...
        'Visible','off', ...
        'HorizontalAlignment','center');
end

for i = 1:nChar2
    cap2(i) = text(xStart2 + (i-1)*xStep2, 0, captionZ2, line2(i), ...
        'Color',[0 0 0], ...
        'FontSize',16, ...
        'FontWeight','bold', ...
        'Visible','off', ...
        'HorizontalAlignment','center');
end

%% ===== TREE =====
levels = 7; height = 10; baseRadius = 4.2;
tree = gobjects(levels,1);

for i = 1:levels
    h = height/levels; z0 = (i-1)*h;
    r = baseRadius*(levels-i+1)/levels;
    [x,y,z] = cylinder(linspace(r,0,40),80);
    z = z*h + z0;
    x = x.*(1+0.05*randn(size(x)));
    y = y.*(1+0.05*randn(size(y)));
    tree(i)=surf(x,y,z,'FaceColor',[0 0.4+0.08*i 0],'EdgeColor','none');
end

%% ===== TRUNK & STAR =====
[xT,yT,zT] = cylinder([0.6 0.6], 40);   
zT = zT * 4.2 - 2;                     

surf(xT, yT, zT, ...
    'FaceColor', [0.4 0.2 0.1], ...
    'EdgeColor', 'none');

[xs,ys,zs] = sphere(40);
star = surf(0.35*xs, 0.35*ys, 0.35*zs + height + 0.3, ...
    'FaceColor', [1 0.9 0.2], ...
    'EdgeColor', 'none');


%% ===== ORNAMENTS =====
numOrn=50; orn=gobjects(numOrn,1);
for i=1:numOrn
    [xo,yo,zo]=sphere(20);
    orn(i)=surf(0.15*xo+(rand-0.5)*2,...
                0.15*yo+(rand-0.5)*2,...
                0.15*zo+rand*height,...
                'FaceColor',rand(1,3),'EdgeColor','none');
end

%% ===== LIGHTS =====
numLights=200;
lights=scatter3((rand(numLights,1)-0.5)*2.4,...
                (rand(numLights,1)-0.5)*2.4,...
                 rand(numLights,1)*height,12,'filled');
lightColors=0.6+0.4*rand(numLights,3);
set(lights,'PickableParts','none','HitTest','off');

%% ===== LIGHTING =====
light('Position',[3 3 10],'Style','infinite');
light('Position',[-3 -2 6],'Style','local');
lighting gouraud
material shiny

%% ===== SKY FIREWORKS (RADIAL BURSTS) =====
fwColors = [ ...
    1.0 0.9 0.0;   % yellow
    1.0 0.5 0.0;   % orange
    0.2 0.4 1.0;   % blue
    0.2 1.0 0.4;   % green
    1.0 0.2 0.8];  % pink / magenta

numSkyFW = 5;
particlesFW = 60;
skyFW = struct();

for i = 1:numSkyFW
    skyFW(i).center = [(rand-0.5)*7, (rand-0.5)*7, height+3+rand];
    skyFW(i).theta  = rand(particlesFW,1)*2*pi;
    skyFW(i).phi    = rand(particlesFW,1)*pi;
    skyFW(i).r      = zeros(particlesFW,1);
    skyFW(i).speed  = 0.08 + 0.05*rand(particlesFW,1);
    skyFW(i).life   = randi([40 80]);
    skyFW(i).color = fwColors(randi(size(fwColors,1)), :);
    skyFW(i).h = scatter3( ...
        skyFW(i).center(1), ...
        skyFW(i).center(2), ...
        skyFW(i).center(3), ...
        18, skyFW(i).color, 'filled');
    set(skyFW(i).h,'PickableParts','none','HitTest','off');
end

%% ===== ROTATING OBJECTS =====
treeObjects=[tree(:);orn(:);star];

%% ===== FullHD MP4 EXPORT =====
exportFullHD = true;
videoFile = 'Merry_Christmas_2025_FullHD_By_Parmesh_Kumar.mp4';

if exportFullHD
    v = VideoWriter(videoFile, 'MPEG-4');
    v.FrameRate = 30;     % cinematic smoothness
    v.Quality   = 100;    % max quality
    open(v);
end

%% ===== ANIMATION LOOP =====
for k=1:480

    % ===== Rotate tree safely =====
    validTree = treeObjects(isgraphics(treeObjects));
    rotate(validTree,[0 0 1],3.2,[0 0 0])

    % ===== Lights glow =====
    if isgraphics(lights)
        set(lights,'CData',lightColors .* (0.4 + 0.6*rand(numLights,1)));
    end

%% ===== LETTER ANIMATION + GLOW (TWO LINES) =====
vis1 = min(nChar1, floor(k/2));
vis2 = min(nChar2, floor((k-20)/2));  % second line appears slightly later

for i = 1:vis1
    if isgraphics(cap1(i))
        cap1(i).Visible = 'on';
        glow = 0.6 + 0.4*sin(k/8 + i);
        cap1(i).Color = [1 glow glow];
        cap1(i).Position(3) = captionZ1 + 0.12*sin(k/15 + i);
    end
end

for i = 1:vis2
    if isgraphics(cap2(i))
        cap2(i).Visible = 'on';
        glow = 0.6 + 0.4*sin(k/8 + i);
        cap2(i).Color = [1 glow glow];
        cap2(i).Position(3) = captionZ2 + 0.10*sin(k/15 + i);
    end
end

    %% ===== SKY FIREWORK ANIMATION =====
for i = 1:numSkyFW
    if isgraphics(skyFW(i).h)
        skyFW(i).r = skyFW(i).r + skyFW(i).speed;

        x = skyFW(i).center(1) + skyFW(i).r .* sin(skyFW(i).phi).*cos(skyFW(i).theta);
        y = skyFW(i).center(2) + skyFW(i).r .* sin(skyFW(i).phi).*sin(skyFW(i).theta);
        z = skyFW(i).center(3) + skyFW(i).r .* cos(skyFW(i).phi);

        set(skyFW(i).h,'XData',x,'YData',y,'ZData',z);
        skyFW(i).h.SizeData = 14 + 18*abs(sin(k/8));

        skyFW(i).life = skyFW(i).life - 1;

        % ===== Reset explosion =====
        if skyFW(i).life <= 0
            skyFW(i).center = [(rand-0.5)*7, (rand-0.5)*7, height+3+rand];
            skyFW(i).r = zeros(particlesFW,1);
            skyFW(i).theta = rand(particlesFW,1)*2*pi;
            skyFW(i).phi   = rand(particlesFW,1)*pi;
            skyFW(i).speed = 0.08 + 0.05*rand(particlesFW,1);
            skyFW(i).life  = randi([40 80]);
            skyFW(i).color = fwColors(randi(3),:);
            skyFW(i).h.CData = skyFW(i).color;
        end
    end
end

if exportFullHD
    frame = getframe(fig);   
    writeVideo(v, frame);
end

    drawnow
end
 % ===== Confirmation of File Export =====
if exportFullHD
    close(v);
    disp('FullHD MP4 export completed successfully!');
end
function demomode()

% clean up..
%delete(timerfindall);

figure(1);
% operate background image...
I = imread('topview.png');
I = imresize(I, [800 NaN]);
padsize = (800-size(I,2))/2;
I = padarray(I, [0 padsize]);
I(:,end-padsize:end,:) = 255;
I(:,1:padsize,:) = 255;
handles.h0 = imshow(I);
hold on;

% load wheel
W = imread('wheel.jpg');

handles.h1 = rectangle('Position', [235,130+100,30,1], 'FaceColor', 'g', 'LineStyle', 'none');
handles.h2 = rectangle('Position', [537,130+100,30,1], 'FaceColor', 'g', 'LineStyle', 'none');
handles.h3 = rectangle('Position', [235,560+100,30,1], 'FaceColor', 'g', 'LineStyle', 'none');
handles.h4 = rectangle('Position', [537,560+100,30,1], 'FaceColor', 'g', 'LineStyle', 'none');

handles.h6 = rectangle('Position', [225,130+100,10,1], 'FaceColor', 'b', 'LineStyle', 'none');
handles.h7 = rectangle('Position', [567,130+100,10,1], 'FaceColor', 'b', 'LineStyle', 'none');
handles.h8 = rectangle('Position', [225,560+100,10,1], 'FaceColor', 'b', 'LineStyle', 'none');
handles.h9 = rectangle('Position', [567,560+100,10,1], 'FaceColor', 'b', 'LineStyle', 'none');

handles.h5 = rectangle('Position', [737,560+100,30,1], 'FaceColor', 'r', 'LineStyle', 'none');

W = imresize(W, [200 200]);
I(1:200,601:800,:) = W;

text(735, 550, 'Brake');

data.W = W;
data.I = I;

t = timer('Executionmode','fixedRate','Period', 0.1,...
        'TimerFcn', {@update_demomode,handles,data});

start(t);
    
end

function update_demomode(~, ~, handles,data)
W = data.W;
I = data.I;

c = Car.getInstance;

%i = rand*100;      % velocity of wheel [0, 100]
%b = rand*100;      % acceleration of wheels [0, 100]
%a = (rand-0.5)*90; % steering wheel angle [-45,45]

v1 = c.cardata.wheelspeeds(end,1)*15+1;
v2 = c.cardata.wheelspeeds(end,2)*15+1;
v3 = c.cardata.wheelspeeds(end,3)*15+1;
v4 = c.cardata.wheelspeeds(end,4)*15+1;

b = sum(c.cardata.acceleration(end)) / 1 + 1; % total acceleration..
r = c.cardata.brake(end) +1;

a = c.cardata.wheeldirection(end);

% rotate steering wheel
W1 = imrotate(W, a, 'crop');
Mrot = ~imrotate(true(size(W)),a,'crop');
W1(Mrot&~imclearborder(Mrot)) = 255;
I(1:200,601:800,:) = W1;
set(handles.h0, 'CData', I);

% show velocity for each wheel
set(handles.h1, 'Position', [235,130+100-v1,30,v1]); %front left
set(handles.h2, 'Position', [537,130+100-v2,30,v2]); %front right
set(handles.h3, 'Position', [235,560+100-v3,30,v3]); %rear left
set(handles.h4, 'Position', [537,560+100-v4,30,v4]); %rear right

set(handles.h6, 'Position', [225,130+100-b,10,b]); %front left
set(handles.h7, 'Position', [567,130+100-b,10,b]); %front right
set(handles.h8, 'Position', [225,560+100-b,10,b]); %rear left
set(handles.h9, 'Position', [567,560+100-b,10,b]); %rear right

set(handles.h5, 'Position', [737,560+100-r,30,r]); %brake

drawnow;

end
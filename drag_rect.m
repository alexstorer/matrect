function drag_rect(imloc)

%figure('WindowButtonMotionFcn',@figButtonMotion);
imshow(imloc)
f = gcf();
set(f,'WindowButtonMotionFcn',@figButtonMotion);
set(f,'WindowButtonUpFcn',@buttonup);
set(f,'KeyPressFcn',@keypress);
set(f,'KeyReleaseFcn',@keyup);

ax = gca();
last_pt = [0 0 1; 0 0 -1];
loc_pt = [0 0 1; 0 0 -1];


np = 1; % number of patches to create
p = zeros(1,np); % patch handles
x = cell(1,np); % shape x-values
y = cell(1,np); % shape y-values
% Create the Patches

dx = 100;
dy = 100;

% tranformations

deg = 0;
offset = [0 0];
xsc = 1;
ysc = 1;

% colors
clr = [0    0.890    0.19215];
alphaval = 0.2;

% some state variables
rotating = 0;
scalex = 0;
scaley = 0;
moving = 0;
titlestr = 'Click box to move. Key options: c, r, x, y';

for k = 1
    sides = 4;
    psi = 2*pi*((0:sides-1)/sides);
    x{k} = dx*cos(psi); % shape XData
    y{k} = dy*sin(psi); % shape YData
    x{k} = [100 -100 -100 100];
    y{k} = [100 100 -100 -100];
    %clr = sqrt(rand(1,3)); % shape Color
    %clr =  [0.8098    0.890    0.19215];
    p(k) = patch(x{k},y{k},clr);
    get(p(k))
    set(p(k),'UserData',k,'ButtonDownFcn',{@patchButtonDown,p(k)},'FaceAlpha',[alphaval]);
end
axis equal
title(titlestr,'FontSize',14)
patch_clicked = 0;
this_p = p(1);
this_k = 1;

% Function for Identifying Clicked Patch
    function patchButtonDown(this,varargin)
        this_p = this;
        this_k = get(this,'UserData');
        %patch_clicked = ~patch_clicked;
        patch_clicked = 1;
        moving = 1;
    end

    function buttonup(varargin)
        disp('Button up!')
        if patch_clicked
            patch_clicked = ~patch_clicked;
            moving = 0;
        end
    end


    function keypress(varargin)
        varargin{2}.Key
        switch varargin{2}.Key
            case 'r'
                title('Rotating: move mouse up and down to rotate','FontSize',14)
                rotating = 1;
            case 'x'
                title('Scaling X-dimension: move mouse up and down to scale','FontSize',14)
                scalex = 1;
            case 'y'
                title('Scaling Y-dimension: move mouse up and down to scale','FontSize',14)
                scaley = 1;
            case 'c'
                title('Toggle color','FontSize',14)
                a = get(this_p,'FaceAlpha');
                set(this_p,'FaceAlpha',alphaval-a);
        end        
    end

    function keyup(varargin)
        switch varargin{2}.Key
            case 'r'
                title(titlestr,'FontSize',14)
                rotating = 0;
            case 'x'
                title(titlestr,'FontSize',14)
                scalex = 0;
            case 'y'
                title(titlestr,'FontSize',14)
                scaley = 0;
            case 'c'
                title(titlestr,'FontSize',14)
        end
        
    end

% Function for Moving Selected Patch
    function figButtonMotion(varargin)
        % Get the Mouse Location
        curr_pt = get(ax,'CurrentPoint');
        % Change the Position of the Patch
        dp = (curr_pt-last_pt);            
        dp = dp(1,2);
        last_pt = curr_pt;

        if rotating
            deg = deg+dp/10;
        elseif scalex
            xsc = xsc + dp/150;
        elseif scaley
            ysc = ysc + dp/150;
        elseif moving
            offset = [curr_pt(1,1) curr_pt(1,2)];
        end
        transformPatch()
    end

    function transformPatch
        %deg = 0;
        %offset = [0 0];
        %xsc = 1;
        %ysc = 1;
        scalemat = [1+xsc 0; 0 1+ysc];
        rotmat = [cosd(deg) sind(deg); -sind(deg) cosd(deg)];
        ptmat = [x{this_k}; y{this_k}]';
        newpt = ptmat * scalemat * rotmat;
        newx = newpt(:,1)';
        newy = newpt(:,2)';
        set(this_p,'XData',newx+offset(1),'YData',newy+offset(2));
    end
end


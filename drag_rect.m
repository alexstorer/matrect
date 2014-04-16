function [f, this_p] = drag_rect(imloc)
global CONTINUE;

%figure('WindowButtonMotionFcn',@figButtonMotion);
imshow(imloc)
f = gcf();
set(f,'WindowButtonMotionFcn',@figButtonMotion);
set(f,'WindowButtonUpFcn',@buttonup);
set(f,'KeyPressFcn',@keypress);
set(f,'KeyReleaseFcn',@keyup);
hold on;
centerpt = plot(0,0);
rotpt = plot(0,0);

ax = gca();
last_pt = [0 0 1; 0 0 -1];

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
curr_offset = [0 0];
xsc = 1;
ysc = 1;
tform = eye(3);

% colors
clr = [0    0.890    0.19215];
alphaval = 0.2;

% some state variables
rotating = 0;
scalex = 0;
scalex_up = 0;
scalex_down = 0;
scaley = 0;
scaley_up = 0;
scaley_down = 0;
moving = 0;

if CONTINUE
    titlestr = 'Close figure to continue. Key options: c, r, x, y, n';
else
    titlestr = 'Close figure to quit. Key options: c, r, x, y, n';
end

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
    set(p(k),'UserData',k,'ButtonDownFcn',{@patchButtonDown,p(k)},'FaceAlpha',[alphaval]);
end
yq = y{k}/10;
xq = x{k}/10;
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
        if patch_clicked
            patch_clicked = ~patch_clicked;
            moving = 0;
        end
    end

    function keypress(varargin)
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
            case '1'
                title('Scaling X-dimension: move mouse up to scale','FontSize',14)
                scalex_up = 1;
            case '2'
                title('Scaling X-dimension: move mouse down to scale','FontSize',14)
                scalex_down = 1;
            case '3'
                title('Scaling Y-dimension: move mouse up to scale','FontSize',14)
                scaley_up = 1;
            case '4'
                title('Scaling Y-dimension: move mouse down to scale','FontSize',14)
                scaley_down = 1;                
            case 'c'
                title('Toggle color','FontSize',14)
                a = get(this_p,'FaceAlpha');
                set(this_p,'FaceAlpha',alphaval-a);
            case 'n'
                CONTINUE = 1-CONTINUE;
                if CONTINUE
                    titlestr = 'Close figure to continue. Key options: c, r, x, y, n';
                else
                    titlestr = 'Close figure to quit. Key options: c, r, x, y, n';
                end
                title('Toggle whether you wish to continue','FontSize',14)
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
            case '1'
                title(titlestr,'FontSize',14)
                scalex_up = 0;
            case '2'
                title(titlestr,'FontSize',14)
                scalex_down = 0;                
            case '3'
                title(titlestr,'FontSize',14)
                scaley_up = 0;
            case '4'
                title(titlestr,'FontSize',14)
                scaley_down = 0;                                
            case 'c'
                title(titlestr,'FontSize',14)
            case 'n'
                title(titlestr,'FontSize',14)                
        end
        
    end

% Function for Moving Selected Patch
    function figButtonMotion(varargin)
        % Get the Mouse Location
        curr_pt = get(ax,'CurrentPoint');
        % Change the Position of the Patch
        dpt = (curr_pt-last_pt);            
        dp = dpt(1,2);
        last_pt = curr_pt;
        if rotating
            deg = deg+dp/10;
            doRotate(dp/10);
        elseif scalex
            xw = getWidth();
            [cx, cy] = getCenter();
            xsc = -dp/xw;
            doTranslate(-cx,-cy);
            doRotate(-deg);
            doScale(1 + xsc,1);
            doRotate(deg);
            doTranslate(cx,cy);            
        elseif scaley
            yw = getHeight();
            [cx, cy] = getCenter();
            ysc = -dp/yw;
            doTranslate(-cx,-cy);
            doRotate(-deg);
            doScale(1,1 + ysc);
            doRotate(deg);
            doTranslate(cx,cy);   
        elseif scalex_up
            xw = getWidth();
            [cx, cy] = getCenter();
            doRotate(-deg);
            doTranslate(-cx,-cy);
            xsc = -dp/xw;
            doScale(1 + xsc,1);
            xww = getWidth();
            dx = (xww - xw)/2;
            doTranslate(dx*cosd(deg),-dx*sind(deg));
            doTranslate(cx,cy);
            doRotate(deg);
        elseif scalex_down
            xw = getWidth();
            [cx, cy] = getCenter();
            doRotate(-deg);
            doTranslate(-cx,-cy);
            xsc = dp/xw;
            doScale(1 + xsc,1);
            xww = getWidth();
            dx = -(xww - xw)/2;
            doTranslate(dx*cosd(deg),-dx*sind(deg));
            doTranslate(cx,cy);
            doRotate(deg);
        elseif scaley_up
            yw = getHeight();
            [cx, cy] = getCenter();
            doRotate(-deg);
            doTranslate(-cx,-cy);
            ysc = dp/yw;
            doScale(1,1 + ysc);
            yww = getHeight();
            dy = (yww - yw)/2;
            doTranslate(dy*sind(deg),dy*cosd(deg));
            doTranslate(cx,cy);
            doRotate(deg);
        elseif scaley_down
            yw = getHeight();
            [cx, cy] = getCenter();
            doRotate(-deg);
            doTranslate(-cx,-cy);
            ysc = -dp/yw;
            doScale(1,1 + ysc);
            yww = getHeight();
            dy = -(yww - yw)/2;
            doTranslate(dy*sind(deg),dy*cosd(deg));
            doTranslate(cx,cy);
            doRotate(deg);
        elseif moving
            offset = offset + dpt([1 3]);
            doTranslate(dpt(1,1),dpt(1,2));
        end
    end

    function doRotate(deg)
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        pts = [xpts'; ypts'; ones(1,length(xpts))];
        curr_location = [mean(xpts), mean(ypts)];
        doTranslate(-curr_location(1),-curr_location(2));
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        pts = [xpts'; ypts'; ones(1,length(xpts))];
        pts = rotmat(deg)*pts;
        set(this_p,'XData',pts(1,:)');
        set(this_p,'YData',pts(2,:)');
        doTranslate(curr_location(1),curr_location(2));
    end

    function [cx, cy] = getCenter()
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        cx = mean(xpts); cy = mean(ypts);
    end

    function [wid] = getWidth()
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        wid = sqrt((xpts(2)-xpts(1))^2 + (ypts(2)-ypts(1))^2);
    end

    function [hgt] = getHeight()
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        hgt = sqrt((xpts(2)-xpts(3))^2 + (ypts(2)-ypts(3))^2);
    end


    function doTranslate(dx,dy)
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        pts = [xpts'; ypts'; ones(1,length(xpts))];
        tform = eye(3);
        tform = tform * tmat(dx,dy);
        pts = tform * pts;
        set(this_p,'XData',pts(1,:)');
        set(this_p,'YData',pts(2,:)');
    end

    function doScale(sx,sy)
        xpts = get(this_p,'XData');
        ypts = get(this_p,'YData');
        pts = [xpts'; ypts'; ones(1,length(xpts))];
        tform = eye(3);
        tform = tform * scalemat(sx,sy);
        pts = tform * pts;
        set(this_p,'XData',pts(1,:)');
        set(this_p,'YData',pts(2,:)');
    end

    function [m] = rotmat(deg)
       m = [cosd(deg) sind(deg) 0;
           -sind(deg) cosd(deg) 0;
           0            0       1];                     
    end

    function [m] = tmat(dx,dy)
       m = [1           0       dx;
            0           1       dy;
            0           0       1];
    end

    function [m] = scalemat(sx,sy)
       m = [sx          0       0;
            0           sy      0;
            0           0       1];
    end
end


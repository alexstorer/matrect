function [f, this_p] = collect_data(direc,id)
    global NEXTIND;
    global CONTINUE;
    
    CONTINUE = 1;
    
    % try to load the .mat file
    try
        load([direc filesep id '.mat'])
    catch
        s = struct('id',id,'lastimg','','data',{{}});
    end
    imgs = dir(direc);
    if size(imgs,1)==0
        error('Directory not found!  Please check your input and try again.');
    end

    imgsc = struct2cell(imgs);    
    imgnames = imgsc(1,:);
    
    NEXTIND = find(strcmp(s.lastimg,imgnames));
    if isempty(NEXTIND)
        NEXTIND = 0;        
    else
    end       
    
    openNext();
    
    
    function saveLocation(p)
        s.data{end+1} = struct('img',imgs(NEXTIND).name,'XData',get(p,'XData'),'YData',get(p,'YData'),'time',datestr(now()));
        s.lastimg = imgs(NEXTIND).name;
        save([direc filesep id '.mat'],'s')
    end

    function figClose(src,evnt)
        saveLocation(this_p)
        if CONTINUE
            openNext();
        else
            delete(gcf);
        end
    end

    function openNext()
        NEXTIND = NEXTIND+1;
        if NEXTIND > length(imgs)
            NEXTIND = 1;
        end        
        imloc = [direc filesep imgs(NEXTIND).name];
        try
            [f, this_p] = drag_rect(imloc);
            set(gcf,'CloseRequestFcn',@figClose);
        catch
            openNext();
        end
    end

end


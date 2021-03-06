function [arteryObj, stentObj] =  expansion_artery_video( arteryObj, stentObj, radius_final, resistance) 
global n_circ;
%TODO first expand until vessel walls are touched, then cylindrical?
steps = 10;
seconds =5;
fId = figure('units','normalized','position',[1 1 1 1]);
hold on
light('Position',[-1.0,-1.0,100.0],'Style','infinite');
lighting gouraud;
writerObj = VideoWriter('images/stentArteryExpanding1.mp4', 'MPEG-4'); % Name it.
writerObj.FrameRate = floor(steps/seconds); % How many frames per second.
writerObj.Quality=100;

open(writerObj);

% go through stent vertices
for i = 3:-1:1
    radius_curr = mean(stentObj(i).radius_avg);
    d = (radius_final(i)-mean(radius_curr))/steps;
    initial_length = stentObj(i).centerline.length;
    
    % artery vertices in vicinity of stentObj i
    relevant_idx = stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0);
    relevant_vertices = arteryObj.vertices(relevant_idx,:);
    relevant_distances = arteryObj.dist_to_center(relevant_idx,:);
    % closest stent point to each artery point
    [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, relevant_vertices,'euclidean','SMALLEST',1);
    % artery points belonging to each stent points
    index_artery_to_stent = get_index(index_stent_to_artery',size(stentObj(i).vertices,1))  ;
    changed =0;            
    for s=1:steps 
        for ii = 1:stentObj(i).centerline.len
            % indices of one circle
            idx = (ii-1)*n_circ+1:(ii)*n_circ;
            radius_avg_curr = mean(stentObj(i).radius(idx));
            if radius_avg_curr < radius_final(i)
                changed = 1;
                % artery points (closest to circle points) that are 
                % closer to the centerline than the circle point
                nn = double(stentObj(i).radius(idx) < stentObj(i).radius_artery(idx));
                nn(nn==0)=resistance;
                % expand the stent points; those at vessel wall less,
                % depending on resistance variable
                stentObj(i).vertices(idx,:)= stentObj(i).vertices(idx,:)+d*nn.*normr(stentObj(i).vertices(idx,:)-stentObj(i).centerline.coords(ii,:));
                % update stent point radii
                stentObj(i).radius(idx,:)= stentObj(i).radius(idx,:)+d*nn;   
                % artery points belonging to current circle
                index_artery_to_circle = index_artery_to_stent(idx,:);
                index_artery_to_circle = index_artery_to_circle(index_artery_to_circle~=0);
                % artery points belonging to stent points (current circle)
                index_artery_to_circle_stent = index_stent_to_artery(index_artery_to_circle);
                % artery points (belonging to circle points) that are
                % closer to the centerline than the expanded circle point
                mm = stentObj(i).radius(index_artery_to_circle_stent) > relevant_distances(index_artery_to_circle,4);
                % index of closest centerline point to artery points
                % (almost always == ii+1)
                [~, idx_c_t_a] = pdist2(stentObj(i).centerline.coords, relevant_vertices(index_artery_to_circle(mm),:),'euclidean','SMALLEST',1);
                relevant_vertices(index_artery_to_circle(mm),:) = arteryObj.centerline(i).coords(idx_c_t_a,:)+stentObj(i).radius(index_artery_to_circle_stent(mm)).* normr(relevant_vertices(index_artery_to_circle(mm),:) - arteryObj.centerline(i).coords(idx_c_t_a,:));
            end
        
        end
        if(changed)
            % check for foreshortening
            stentObj(i).radius_avg = mean(stentObj(i).radius);
            scale = interp1(stentObj(i).params(:,1), stentObj(i).params(:,2), stentObj(i).radius_avg,'linear','extrap') ; % initial radius * 2 /2 -> params are lumen
            if isnan(scale) || scale > 1 
                scale = 1;
            elseif scale < 0
                    scale = 0.1;
            end
            truncat_idx = find(cumsum(stentObj(i).centerline.seglen)>initial_length*scale,1,'first')+1;
            stentObj(i) = truncate_stent(stentObj(i),truncat_idx);
        end
        % update artery vertices
        arteryObj.vertices(relevant_idx,:) = relevant_vertices;
        figure(fId); % Makes sure you use your desired frame.
       	%draw_artery_stents(arteryObj, connect_stents(stentObj));
        draw_artery_real_stents(arteryObj, stentObj); 
        frame = getframe(fId); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
    end
    
    % update artery vertices
    %arteryObj.vertices(relevant_idx,:) = relevant_vertices;
    
end
close(writerObj); % Saves the movie.


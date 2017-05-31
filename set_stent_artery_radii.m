function stentObj = set_stent_artery_radii(arteryObj, stentObj)
    for i=1:3
        %TODO split artery in  3 parts to have relevant vertices right away
        % artery vertices in vicinity of stentObj i
        relevant_vertices = arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
        relevant_distances = arteryObj.dist_to_center(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),4);
        % index of closest artery point to each stent point
        [~,idx_closest_artery] = pdist2( relevant_vertices,stentObj(i).vertices, 'euclidean','SMALLEST',1);
        stentObj(i).radius_artery = relevant_distances(idx_closest_artery);%mean(relevant_distances(index_artery_to_stent(index_artery_to_stent~=0)));
    end
end
classdef Centerline 
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        tangents;
        index_artery_to_center; % index of artery points belonging to each centerline point
        index_stent_to_center;
        seglen;
        len;
        length;
    end
    
    methods
        function centerlineObj = Centerline(coords, tangents) 
            if nargin == 2
                centerlineObj.coords = coords;
                centerlineObj.tangents = normr(tangents);
                centerlineObj.seglen = sqrt(sum(diff(centerlineObj.coords,[],1).^2,2));
                centerlineObj.len = size(coords,1);
                centerlineObj.length = sum(centerlineObj.seglen);
            end
        end
        
    end
    
end
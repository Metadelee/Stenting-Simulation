%% 1. Read in artery.stl (and possibly display)
[faces, vertices, ~] = read_stl('test_artery.stl', true);

% display artery
draw_artery(vertices, faces)
hold on; 
% read in centerline
[ center_coords1, center_tangent1 ] = read_path( 'test_path1.pth' );
[ center_coords2, center_tangent2 ] = read_path( 'test_path2.pth' );
draw_centerline(center_coords1)
centers = [center_coords1; center_coords2(2:end)];

% find bifurcation point
[~,bif_1,bif_2] = intersect(center_coords1,center_coords2,'rows');


% compute radii

%% 2. Read in stent
[stent_V,stent_F] = read_vertices_and_faces_from_obj_file('s_stent.obj', false);

%% 3. Stenosis detection

%% 4. Stent placement
% stent scaling


%% 5. Stenting
% stent expansion and foreshortening

% possibly smoothing with smooth3
function draw_closest_points(center,vertices, index_closest,i)

     for j = 1:nnz(index_closest(i,:))
         plot3([vertices(index_closest(i,j),1), center(i, 1)],[vertices(index_closest(i,j),2), center(i, 2)],[vertices(index_closest(i,j),3), center(i, 3)],'-', 'Color','b');hold on;
     end;
    
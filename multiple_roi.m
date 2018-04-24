% Open the video
clear all; close all; clc;

currAxes = axes;
v = VideoReader('.\vids\d2.mp4')
%v = VideoReader('.\vids\test.mp4')
%v = VideoReader('.\vids\test_input2.mp4')
%v = VideoReader('.\vids\test2.mp4')
%v.CurrentTime = 2.5;

sample_frame = readFrame(v);
dimensions = size(sample_frame);

xi = [0 1 0.65 0.35 0];%*dimensions(2);
yi = [1 1 0.65 0.65 1];%*dimensions(1); 
roi_horizontal_slice = 3;
roi_vertical_slice = 1;
y_step = (max(yi) - min(yi)) / roi_horizontal_slice;
x_step = (xi(2) - xi(3)) / roi_horizontal_slice;
% coordinates of the x axes of multiple rois
roi_x = zeros(roi_horizontal_slice, 5);
roi_y = zeros(roi_horizontal_slice, 5); 
for i = 0:(roi_horizontal_slice-1)
    roi_x(i+1,:) = [i*x_step (1-i*x_step) (1-(i+1)*x_step) ((i+1)*x_step) i*x_step];
    roi_y(i+1,:) = [(1-i*y_step) (1-i*y_step) (1-(i+1)*y_step) (1-(i+1)*y_step) (1-i*y_step)];

end

roi_x_pixel = roi_x * dimensions(2);
roi_y_pixel = roi_y * dimensions(1);

BW = zeros(roi_horizontal_slice, dimensions(1), dimensions(2));
for i = 1:roi_horizontal_slice
    BW(i,:,:) = poly2mask(roi_x_pixel(i,:), roi_y_pixel(i,:), dimensions(1), dimensions(2));
end


while hasFrame(v)
    
    % Img = imread('coins.png');
    % imshow(edge(Img,'Sobel'))

    video = readFrame(v);
    I = rgb2gray(video);

    blur2 = imgaussfilt(I,5);
    edges = edge(blur2, 'Canny');
%     figure; imshow(blur2);
%     figure; imshow(edges), title('Canny with sigma=5 Gaussian Blur')

    size(video);
    dimensions = size(video);
    
    left_longest_lines = zeros(roi_horizontal_slice, 2, 2);
    right_longest_lines = zeros(roi_horizontal_slice, 2, 2);
    
    %BW = poly2mask(xi,yi,dimensions(1), dimensions(2));
    %BW_int = uint8(BW);
%     figure; imshow(BW)
%     figure; imshow(video); title('Raw Frame')
    %H = fspecial('unsharp');
    for i = 1:roi_horizontal_slice
        masked_frame = edges .* squeeze(BW(i,:,:));
        %imshow(masked_frame)


        % Create the Hough transform using the binary image.
        [H,T,R] = hough(masked_frame);
        P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));    
        lines = houghlines(masked_frame,T,R,P,'FillGap',5,'MinLength',35);
        
        
        imshow(video), hold on
        max_llen = 0; max_rlen=0; % max right lane and left lane length
        for k = 1:length(lines)
           xy = [lines(k).point1; lines(k).point2];
           
           % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

    %      Determine the endpoints of the longest line segment
           len = norm(lines(k).point1 - lines(k).point2);
           if(xy(1,1) < dimensions(2)*0.5)
               if (len > max_llen)
                  max_llen = len;
                  left_longest_lines(i,:,:) = xy;
               end
           else
                if (len > max_rlen)
                  max_rlen = len;
                  right_longest_lines(i,:,:) = xy;
                end
           end

        end       
        
    end
    
    for i = 1:roi_horizontal_slice
        plot(left_longest_lines(i,:,1), left_longest_lines(i,:,2),'LineWidth',2,'Color','cyan');
        plot(right_longest_lines(i,:,1),right_longest_lines(i,:,2),'LineWidth',2,'Color','cyan');
        %image(video, 'Parent', currAxes);
        %currAxes.Visible = 'off';          
    end
    
    for i = 1:4
        plot(roi_x_pixel(1,i), roi_y_pixel(1,i), roi_x_pixel(1,i+1), roi_y_pixel(1,i+1), 'LineWidth', 2, 'Color', 'red');
    end
    
   pause(1/(v.FrameRate*10000));
  % imshow(masked_frame);
  % imshow(
   
end

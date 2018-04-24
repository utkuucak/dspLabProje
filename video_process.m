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

xi = [0 1 0.65 0.35 0]*dimensions(2);
yi = [1 1 0.5 0.5 1]*dimensions(1); 
BW = poly2mask(xi,yi,dimensions(1), dimensions(2));

pleft_line = 0; pright_line = 0
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
   
    %BW_int = uint8(BW);
%     figure; imshow(BW)
%     figure; imshow(video); title('Raw Frame')
    %H = fspecial('unsharp');
    masked_frame = edges .* BW;
%     figure; imshow(masked_frame)


    % Create the Hough transform using the binary image.
    [H,T,R] = hough(masked_frame);
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(masked_frame,T,R,P,'FillGap',30,'MinLength',15);  
    
    
    imshow(video), hold on
    max_llen = 0; max_rlen=0; % max right and left length
    for k = 1:length(lines)
        line = lines(k);
         % xy = [lines(k).point1; lines(k).point2];
         % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
       % Plot beginnings and ends of lines
       % plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%      Determine the endpoints of the longest line segment
       len = norm(line.point1 - line.point2);
       
       % check if slope of the line negative
       if(line.theta < 0)
            if (len > max_llen)
              max_llen = len;
              max_left_line = line;
              if any( structfun(@isempty, pleft_line) )
                pleft_line = max_left_line;
              elseif abs(max_left_line.theta - pleft_line.theta) > 5
                  max_left_line = pleft_line;
              else
                  pleft_line = max_left_line;
              end
            end
       % begining of the line is at the right side    
       else
            if (len > max_rlen)
              max_rlen = len;
              max_right_line = line;
              if pright_line == 0
                pright_line = max_right_line;
              elseif abs(max_right_line.theta - pright_line.theta) > 5
                  max_right_line = pright_line;
              else
                  pright_line = max_right_line;
                  
              end
            end
       end

    end

    plot(max_left_line.point1,max_left_line.point2,'LineWidth',2,'Color','cyan');
    plot(max_right_line.point1,max_right_line.point2,'LineWidth',2,'Color','cyan');
    %image(video, 'Parent', currAxes);
    %currAxes.Visible = 'off';   
    pause(1/(v.FrameRate*1000000));
    %subplot(2,1,2); imshow(masked_frame);
end

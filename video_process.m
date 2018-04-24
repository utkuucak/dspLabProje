% Open the video
clear all; close all; clc;

currAxes = axes;
%v = VideoReader('.\vids\d2.mp4')
%v = VideoReader('.\vids\test.mp4')
%v = VideoReader('.\vids\test_input2.mp4')
v = VideoReader('.\vids\test2.mp4')
%v.CurrentTime = 2.5;
sample_frame = readFrame(v);
dimensions = size(sample_frame);

xi = [0 1 0.65 0.35 0]*dimensions(2);
yi = [1 1 0.5 0.5 1]*dimensions(1); 
BW = poly2mask(xi,yi,dimensions(1), dimensions(2));


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
  %   figure; imshow(H,[],'XData',T,'YData',R,...
   %             'InitialMagnification','fit');
%     xlabel('\theta'), ylabel('\rho');
%     axis on, axis normal, hold on;

    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
%     x = T(P(:,2)); y = R(P(:,1));
%     plot(x,y,'s','color','white');

    lines = houghlines(masked_frame,T,R,P,'FillGap',15,'MinLength',15);
    % subplot(2,1,1); imshow(masked_frame);
    %subplot(2,1,2);
    imshow(video), hold on
    max_llen = 0; max_rlen=0; % max right and left length
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
       % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%      Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if(xy(1,1) < dimensions(2)*0.5)
           if (len > max_llen)
              max_llen = len;
              xy_llong = xy;
           end
       else
            if (len > max_rlen)
              max_rlen = len;
              xy_rlong = xy;
            end
       end

    end

    plot(xy_llong(:,1),xy_llong(:,2),'LineWidth',2,'Color','cyan');
    plot(xy_rlong(:,1),xy_rlong(:,2),'LineWidth',2,'Color','cyan');
    %image(video, 'Parent', currAxes);
    %currAxes.Visible = 'off';   
    pause(1/(v.FrameRate*1000000));
    %subplot(2,1,2); imshow(masked_frame);
end

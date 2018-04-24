% Open the video
clear all; close all; clc;


v = VideoReader('.\vids\d2.mp4')
%v = VideoReader('.\vids\test.mp4')
%v = VideoReader('.\vids\test_input2.mp4')
%v = VideoReader('.\vids\test2.mp4')
% Img = imread('coins.png');
% imshow(edge(Img,'Sobel'))

video = readFrame(v);
I = rgb2gray(video);

blur2 = imgaussfilt(I,5);
edges = edge(blur2, 'Canny');
figure; imshow(blur2);
figure; imshow(edges), title('Canny with sigma=5 Gaussian Blur')

size(video);
dimensions = size(video);
xi = [0.1 0.9 0.75 0.25 0.1]*dimensions(2);
yi = [1 1 0.4 0.4 1]*dimensions(1); 
BW = poly2mask(xi,yi,dimensions(1), dimensions(2));
%BW_int = uint8(BW);
figure; imshow(BW)
figure; imshow(video); title('Raw Frame')
%H = fspecial('unsharp');
masked_frame = edges .* BW;
figure; imshow(masked_frame)


% Create the Hough transform using the binary image.
[H,T,R] = hough(masked_frame);
figure; imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(masked_frame,T,R,P,'FillGap',8,'MinLength',7);
figure, imshow(video), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
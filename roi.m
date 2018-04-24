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
size(video);
dimensions = size(video);
xi = [0.1 0.9 0.75 0.25 0.1]*dimensions(2);
yi = [1 1 0.4 0.4 1]*dimensions(1); 

BW = poly2mask(xi,yi,dimensions(1),dimensions(2));
BW_int = uint8(BW);
figure; imshow(BW)
figure; imshow(video); title('Raw Frame')
%H = fspecial('unsharp');
masked_frame = I .* BW_int;
figure; imshow(masked_frame)

%BW = roipoly(video)
% Open the video
clear all; close all; clc;


%v = VideoReader('.\vids\d2.mp4')
%v = VideoReader('.\vids\test.mp4')
%v = VideoReader('.\vids\test_input2.mp4')
v = VideoReader('.\vids\test2.mp4')
% Img = imread('coins.png');
% imshow(edge(Img,'Sobel'))

video = readFrame(v);
figure; imshow(video); title('Raw Frame')
I = rgb2gray(video);
figure; imshow(I); title('Grayscale Image')
canny0 = edge(I, 'Canny');
figure; imshow(canny0); title('No Blur')
blur0 = imgaussfilt(I);
canny1 = edge(blur0, 'Canny');
figure; imshow(canny1), title('Canny with sigma=0.5 Gaussian Blur')

blur1 = imgaussfilt(I,3);
canny2 = edge(blur1, 'Canny');
figure; imshow(canny2), title('Canny with sigma=3 Gaussian Blur')

blur2 = imgaussfilt(I,5);
canny3 = edge(blur2, 'Canny');
figure; imshow(blur2);
figure; imshow(canny3), title('Canny with sigma=5 Gaussian Blur')


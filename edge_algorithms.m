% Open the video
clear all; close all; clc;


v = VideoReader('.\vids\d2.mp4')
% Img = imread('coins.png');
% imshow(edge(Img,'Sobel'))

video = readFrame(v);
I = rgb2gray(video);
figure; imshow(I)
I = imgaussfilt(I, 3);
BW0 = edge(I, 'Canny');
figure; imshow(BW0), title('Canny')
BW1 = edge(I, 'Sobel');
figure; imshow(BW0), title('Sobel')
BW2 = edge(I, 'Prewitt');
figure; imshow(BW0), title('Prewitt')
BW3 = edge(I, 'Roberts');
figure; imshow(BW0), title('Roberts')
BW4 = edge(I, 'log');
figure; imshow(BW0), title('log')
BW5 = edge(I, 'zerocross');
figure; imshow(BW0), title('zerocross')
BW6 = edge(I, 'approxcanny');
figure; imshow(BW0), title('approxcanny')

%imshow(video)

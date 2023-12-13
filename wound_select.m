% Script to read an image and prompt the user to select points on that image using the mouse
% Image name can be changed by the user

im = imead('Exp1_cell1_wound.tif');
[x, y] = getpts();
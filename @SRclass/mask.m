function [x,y,s] = mask(a,idx,orient,vals)

[xc,yc] = fm_draw('circle','SSR',orient);
[xg,yg] = fm_draw('G','SSR',orient);
[xs,ys] = fm_draw('sinus','SSR',orient);

x = cell(9,1);
y = cell(9,1);
s = cell(9,1);

x{1} = 0;
y{1} = -50;
s{1} = 'k';

x{2} = 450;
y{2} = 50;
s{2} = 'k';

x{3} = [0 30 30 38 53 68 83 98 113 120 120 150];
y{3} = [0 0 0 25 -25 25 -25 25 -25 0 0 0];
s{3} = 'k';

x{4} = [0 23 23 24 28 34 40 47 52 55 56 54 51 51 47 ...
        46 48 51 57 64 70 75 79 79 77 74 74 70 69 ...
        71 75 80 87 93 99 102 103 101 97 97 94 93 ...
        94 98 104 110 117 122 125 126 126 150]+150;
y{4} = [0 0 1 11 19 24 25 23 17 8 -2 -12 -18 -18 ...
        -9 1 11 19 24 25 23 17 8 -2 -12 -18 -18 ...
        -9 1 11 19 24 25 23 17 8 -2 -12 -18 -18 ...
        -9 1 11 19 24 25 23 17 8 0 0 0];
s{4} = 'k';

x{5} = [0 60 60 57 55 57 60 60 57 55]+300;
y{5} = [0 0 8 16 25 16 8 -8 -16 -25];
s{5} = 'k';

x{6} = [90 90 90 150]+300;
y{6} = [25 -25 0 0];
s{6} = 'k';

x{7} = -150+60*0.12*xs+60;
y{7} = 40*0.15*ys-40*0.6;
s{7} = 'k';

x{8} = -150+60*(xc+1.4);
y{8} = 40*yc;
s{8} = 'k';

x{9} = -150+60*0.45*(xg+1.4)+60*0.75;
y{9} = 40*0.45*yg+40*0.3;
s{9} = 'b';

[x,y] = fm_maskrotate(x,y,orient);
